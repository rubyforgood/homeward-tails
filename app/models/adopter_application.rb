# == Schema Information
#
# Table name: adopter_applications
#
#  id              :bigint           not null, primary key
#  notes           :text
#  profile_show    :boolean          default(TRUE)
#  status          :integer          default("awaiting_review")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  person_id       :bigint           not null
#  pet_id          :bigint           not null
#
# Indexes
#
#  index_adopter_applications_on_organization_id  (organization_id)
#  index_adopter_applications_on_person_id        (person_id)
#  index_adopter_applications_on_pet_id           (pet_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (pet_id => pets.id)
#
class AdopterApplication < ApplicationRecord
  belongs_to :pet, touch: true
  belongs_to :person
  acts_as_tenant(:organization)

  validates :pet_id, uniqueness: {scope: :person_id}

  enum :status, [:awaiting_review,
    :under_review,
    :adoption_pending,
    :withdrawn,
    :successful_applicant,
    :adoption_made,
    :awaiting_data]

  # remove adoption_made status as not necessary for staff
  def self.app_review_statuses
    AdopterApplication.statuses.keys.map do |status|
      unless status == "adoption_made"
        [status.titleize, status]
      end
    end.compact!
  end

  def self.retire_applications(pet_id:)
    where(pet_id:).each do |adopter_application|
      adopter_application.update!(status: :adoption_made)
    end
  end

  def applicant_name
    person.full_name.to_s
  end

  def withdraw
    update!(status: :withdrawn)
  end

  ransacker :applicant_name do
    Arel.sql("CONCAT(people.last_name, ', ', people.first_name)")
  end

  ransacker :status, formatter: proc { |v| statuses[v] } do |parent|
    parent.table[:status]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["applicant_name", "status"]
  end
end
