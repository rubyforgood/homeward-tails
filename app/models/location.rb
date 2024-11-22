# == Schema Information
#
# Table name: locations
#
#  id              :bigint           not null, primary key
#  city_town       :string
#  country         :string
#  province_state  :string
#  zipcode         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#
# Indexes
#
#  index_locations_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Location < ApplicationRecord
  belongs_to :organization

  validates :country, presence: true, length: {maximum: 50, message: "50 characters maximum"}
  validates :city_town, presence: true, length: {maximum: 50, message: "50 characters maximum"}
  validates :province_state, presence: true, length: {maximum: 50, message: "50 characters maximum"}

  # custom error messages for adopter profile validations
  def custom_messages(attribute)
    errors.where(attribute)
  end
end
