# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  deactivated_at         :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tos_agreement          :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#  organization_id        :bigint
#  person_id              :bigint           not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_organization_id       (organization_id)
#  index_users_on_person_id             (person_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
class User < ApplicationRecord
  include Avatarable
  include Authorizable
  include RoleChangeable

  acts_as_tenant(:organization)
  default_scope do
    #
    # Used as a extra measure to scope down the options for devise
    # when the Current.organization is set
    #
    if Current.organization
      where(organization_id: Current.organization&.id)
    else
      all
    end
  end

  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {scope: :organization_id}, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }
  # validates :tos_agreement, acceptance: {message: "Please accept the Terms and Conditions"},
  #   allow_nil: false, on: :create

  belongs_to :person

  before_validation :ensure_person_exists, on: :create

  before_save :downcase_email

  delegate :latest_form_submission, to: :person

  def self.staff
    joins(:roles).where(roles: {name: %i[admin super_admin]})
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[matches]
  end

  # used in views to show only the custom error msg without leading attribute
  def custom_messages(attribute)
    errors.where(attribute)
  end

  def active_for_authentication?
    super && !deactivated?
  end

  def inactive_message
    deactivated? ? :deactivated : super
  end

  def ensure_person_exists
    return if person.present?

    existing = Person.find_by(organization: organization, email: email)

    if existing
      self.person = existing
    else
      build_person(first_name:, last_name:, email:, organization:)
    end
  end

  def full_name(format = :default)
    case format
    when :default
      "#{first_name} #{last_name}"
    when :last_first
      "#{last_name}, #{first_name}"
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end
  end

  def name_initials
    full_name.split.map { |part| part[0] }.join.upcase
  end

  def deactivate
    update!(deactivated_at: Time.now) unless deactivated_at
  end

  def activate
    update!(deactivated_at: nil) if deactivated_at
  end

  def deactivated?
    !!deactivated_at
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
