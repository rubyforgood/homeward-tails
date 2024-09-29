# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  phone           :string
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

  acts_as_tenant(:organization)

  has_one :latest_form_submission, -> { order(created_at: :desc) }, class_name: "FormSubmission"
  has_many :form_submissions, dependent: :destroy
  has_many :form_answers, through: :form_submissions
  has_many :adopter_applications, through: :form_submissions
  has_many :likes, dependent: :destroy
  has_many :liked_pets, through: :likes, source: :pet
  has_many :matches # , dependent: :destroy

  has_one :user, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
    uniqueness: {case_sensitive: false, scope: :organization_id}

  scope :adopters, -> {
    joins(user: :roles).where(roles: {name: "adopter"})
  }

  scope :fosterers, -> {
    joins(user: :roles).where(roles: {name: "fosterer"})
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name]
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
end
