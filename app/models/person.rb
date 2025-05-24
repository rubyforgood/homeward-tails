# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  phone_number    :string(15)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  user_id         :bigint
#
# Indexes
#
#  index_people_on_email                        (email)
#  index_people_on_organization_id              (organization_id)
#  index_people_on_organization_id_and_user_id  (organization_id,user_id) UNIQUE WHERE (user_id IS NOT NULL)
#  index_people_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class Person < ApplicationRecord
  include Avatarable
  include Phoneable
  include Exportable
  include Authorizable

  belongs_to :user, optional: true
  acts_as_tenant(:organization)

  has_one :latest_form_submission, -> { order(created_at: :desc) }, class_name: "FormSubmission"
  has_many :form_submissions, dependent: :destroy
  has_many :form_answers, through: :form_submissions
  has_many :adopter_applications, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_pets, through: :likes, source: :pet
  has_one :location, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :location,
    reject_if: ->(attributes) { attributes["city_town"].blank? }
  has_many :matches # , dependent: :destroy
  has_many :person_groups
  has_many :groups, through: :person_groups
  has_one :note, as: :notable, dependent: :destroy

  delegate :content, to: :note, allow_nil: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false, scope: :organization_id}
  validates :user_id, uniqueness: {scope: :organization_id}, allow_nil: true
  validates :phone_number, phone: true, if: :phone_number?

  delegate :activate!, :deactivate!, to: :activation
  delegate :add_group, :active_in_group?, :deactivated_in_org?, to: :group_member
  delegate :staff?, to: :staff
  delegate :active?, :current_group, :change_group, to: :staff, prefix: :staff

  scope :adopters, -> {
    joins(:groups).where(groups: {name: :adopter})
  }

  scope :fosterers, -> {
    joins(:groups).where(groups: {name: :fosterer})
  }

  scope :staff, -> {
    joins(:groups).where(groups: {name: [:admin, :super_admin]})
  }

  scope :active_staff, -> {
    joins(groups: :person_groups)
      .where(groups: {name: [:admin, :super_admin]})
      .where(person_groups: {deactivated_at: nil})
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name email]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[matches]
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

  private

  def activation
    @activation ||= GroupRoleManagement::Activation.new(self)
  end

  def group_member
    @group_member ||= GroupRoleManagement::GroupMember.new(self)
  end

  def staff
    @staff ||= GroupRoleManagement::Staff.new(self)
  end

  def note
    super || build_note
  end
end
