# == Schema Information
#
# Table name: pets
#
#  id                 :bigint           not null, primary key
#  age                :integer
#  age_unit           :integer          default("months")
#  application_paused :boolean          default(FALSE)
#  breed              :string
#  description        :text
#  name               :string
#  pause_reason       :integer          default("not_paused")
#  sex                :string
#  size               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  organization_id    :bigint           not null
#
# Indexes
#
#  index_pets_on_name             (name) UNIQUE
#  index_pets_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Pet < ApplicationRecord
  acts_as_tenant(:organization)

  has_many :adopter_applications, dependent: :destroy
  has_one :adoption, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true
  validates :age, presence: true
  validates :age_unit, presence: true
  validates :size, presence: true
  validates :breed, presence: true
  validates :sex, presence: true
  validates :description, presence: true, length: {maximum: 1000}

  # active storage validations gem
  validates :images, content_type: {in: ["image/png", "image/jpeg"],
                                    message: "must be PNG or JPEG"},
    limit: {max: 5, message: "- 5 maximum"},
    size: {between: 10.kilobyte..1.megabytes,
           message: "size must be between 10kb and 1Mb"}

  enum :age_unit, [:months, :years]

  enum :pause_reason, [:not_paused,
    :opening_soon,
    :paused_until_further_notice]

  # check if pet has any applications with adoption pending status
  def has_adoption_pending?
    adopter_applications.any? { |app| app.status == "adoption_pending" }
  end

  # remove not_paused status as not necessary for staff
  def self.app_pause_reasons
    Pet.pause_reasons.keys.map do |reason|
      [reason.titleize, reason]
    end.drop(1)
  end

  def self.list_age_units
    Pet.age_units.keys.map do |unit|
      [unit.titleize, unit]
    end
  end

  # active storage: using.attach for appending images per rails guide
  def append_images=(attachables)
    images.attach(attachables)
  end

  # all pets under an organization
  def self.org_pets(staff_org_id)
    Pet.where(organization_id: staff_org_id)
  end

  # all pets under an organization with applications and no adoptions
  def self.org_pets_with_apps(staff_org_id)
    Pet.org_pets(staff_org_id).includes(:adopter_applications).where
      .not(adopter_applications: {id: nil}).includes(:adoption)
      .where(adoption: {id: nil})
  end

  # all unadopted pets under all organizations
  def self.all_unadopted_pets
    Pet.includes(:adoption).where(adoption: {id: nil})
  end

  # all unadopted pets under an organization
  def self.unadopted_pets(staff_org_id)
    Pet.org_pets(staff_org_id).includes(:adoption).where(adoption: {id: nil})
  end

  # all adopted pets under an organization
  def self.adopted_pets(staff_org_id)
    Pet.org_pets(staff_org_id).includes(:adoption)
      .where.not(adoption: {id: nil})
  end
end
