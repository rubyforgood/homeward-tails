# == Schema Information
#
# Table name: locations
#
#  id             :bigint           not null, primary key
#  city_town      :string
#  country        :string
#  locatable_type :string           not null
#  province_state :string
#  zipcode        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  locatable_id   :bigint           not null
#
# Indexes
#
#  index_locations_on_locatable  (locatable_type,locatable_id)
#
class Location < ApplicationRecord
  belongs_to :locatable, polymorphic: true

  validates :country, presence: true, length: {maximum: 50, message: "50 characters maximum"}
  validates :city_town, presence: true, length: {maximum: 50, message: "50 characters maximum"}
  validates :province_state, presence: true, length: {maximum: 50, message: "50 characters maximum"}

  # custom error messages for adopter profile validations
  def custom_messages(attribute)
    errors.where(attribute)
  end
end
