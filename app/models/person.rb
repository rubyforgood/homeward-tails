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
#
# Indexes
#
#  index_people_on_email            (email)
#  index_people_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Person < ApplicationRecord
  include Avatarable
  include Phoneable
  include Exportable

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

  has_one :user, dependent: :destroy
  has_one :note, as: :notable, dependent: :destroy

  delegate :notes, to: :note, allow_nil: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
    uniqueness: {case_sensitive: false, scope: :organization_id}
  validates :phone_number, phone: true, if: :phone_number?

  scope :adopters, -> {
    joins(user: :roles).where(roles: {name: "adopter"})
  }

  scope :fosterers, -> {
    joins(user: :roles).where(roles: {name: "fosterer"})
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

  def note
    super || build_note
  end
end
