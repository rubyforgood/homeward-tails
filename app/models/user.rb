# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tos_agreement          :boolean
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Avatarable
  include Omniauthable

  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }
  validate :prevent_email_change, on: :update
  validates :tos_agreement, acceptance: true

  has_many :people
  has_many :organizations, through: :people
  accepts_nested_attributes_for :people
  before_save :downcase_email
  delegate :latest_form_submission, to: :person

  # we do not allow updating of email on User because we also store email on Person, however there is a need for the values to be the same
  def prevent_email_change
    errors.add(:email, "Email cannot be changed") if email_changed?
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

  # If a User has a Person in Org A that is deactived (no PersonGroup with deactivated_at: nil) they cannot
  # log in while scoped to Org A. If the User has no Person in Org B or at least one active Group in Org B,
  # they can log in while scoped to Org B.
  def active_for_authentication?
    return super unless Current.organization

    super && active_for_devise?
  end

  # used with devise active_for_authentication?
  def inactive_message
    return super unless Current.organization

    active_for_devise? ? super : :deactivated
  end

  def google_oauth_user?
    provider == "google_oauth2" && uid.present?
  end

  private

  def active_for_devise?
    # this should be used while scoped with ActsAsTenant so only one record is returned
    ActsAsTenant.with_tenant(Current.organization) do
      person = people.first

      @result = !person || !person.deactivated_in_org?
    end
    @result
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
