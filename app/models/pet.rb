# == Schema Information
#
# Table name: pets
#
#  id                 :bigint           not null, primary key
#  application_paused :boolean          default(FALSE), not null
#  birth_date         :datetime         not null
#  breed              :string
#  description        :text
#  name               :string
#  placement_type     :integer          not null
#  published          :boolean          default(FALSE), not null
#  sex                :string
#  species            :integer          not null
#  weight_from        :integer          not null
#  weight_to          :integer          not null
#  weight_unit        :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  organization_id    :bigint           not null
#
# Indexes
#
#  index_pets_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Pet < ApplicationRecord
  include PetRansackable
  include PetTaskable

  acts_as_tenant(:organization)

  has_many :adopter_applications, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many_attached :images
  has_many_attached :files

  validates :name, presence: true
  validates :birth_date, presence: true
  validates :breed, presence: true
  validates :published, inclusion: [true, false]
  validates :sex, presence: true
  validates :species, presence: true
  validates :placement_type, presence: true
  validates :weight_from, presence: true, numericality: {only_integer: true}
  validates :weight_to, presence: true, numericality: {only_integer: true}
  validates :weight_unit, presence: true
  validates :weight_unit, inclusion: {in: %w[lb kg]}
  validates_comparison_of :weight_to, greater_than: :weight_from
  validates :description, presence: true, length: {maximum: 1000}

  # active storage validations gem
  validates :images, content_type: {in: ["image/png", "image/jpeg"]},
    limit: {max: 5},
    size: {between: 10.kilobyte..1.megabytes}

  validates :files, content_type: {in: ["image/png", "image/jpeg", "application/pdf"]},
    limit: {max: 15, message: "- 15 maximum"},
    size: {between: 10.kilobyte..2.megabytes}

  validate :sensible_placement_type

  enum :species, {"Dog" => 1, "Cat" => 2}
  enum :placement_type, ["Adoptable", "Fosterable", "Adoptable and Fosterable"]

  WEIGHT_UNIT_LB = "lb".freeze
  WEIGHT_UNIT_KG = "kg".freeze

  WEIGHT_UNITS = [
    WEIGHT_UNIT_LB,
    WEIGHT_UNIT_KG
  ]

  scope :adopted, -> { joins(:matches).merge(Match.adoptions) }
  scope :unadopted, -> { where.not(id: Pet.adopted) }
  scope :unmatched, -> { includes(:matches).where(matches: {id: nil}) }
  scope :published, -> { where(published: true) }
  scope :fostered, -> { joins(:matches).merge(Match.fosters) }
  scope :fosterable, -> {
    where(placement_type: ["Fosterable", "Adoptable and Fosterable"])
  }
  scope :with_photo, -> { where.associated(:images_attachments) }
  scope :filter_by_application_status, ->(status_filter) {
    joins(:adopter_applications).where(adopter_applications: {status: status_filter})
  }

  # Returns an array of all published breeds; Can be filtered by species ('dog')
  scope :breeds, ->(species = nil) {
    query = species ? where(species: species.capitalize) : all
    query.where(published: true).order(:breed).distinct.pluck(:breed)
  }

  attr_writer :toggle

  # check if pet has any applications with adoption pending status
  def has_adoption_pending?
    adopter_applications.any? { |app| app.status == "adoption_pending" }
  end

  def is_adopted?
    if matches.loaded?
      matches.any? { |m| m.match_type == "adoption" }
    else
      matches.adoption.any?
    end
  end

  def in_foster?
    if matches.loaded?
      matches.any? { |m| m.match_type == "foster" && (m.start_date..m.end_date).cover?(Time.now.utc) }
    else
      matches.in_foster.any?
    end
  end

  def open?
    !is_adopted? && !in_foster?
  end

  # active storage: using.attach for appending images per rails guide
  def append_images=(attachables)
    images.attach(attachables)
  end

  def sensible_placement_type
    if matches.where(end_date: DateTime.now..).exists? && placement_type == "Adoptable"
      errors.add(:placement_type, I18n.t("activerecord.errors.models.pet.attributes.placement_type.sensible"))
    end
  end
end
