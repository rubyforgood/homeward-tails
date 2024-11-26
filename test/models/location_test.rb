require "test_helper"

class LocationTest < ActiveSupport::TestCase
  context "validations" do
    should validate_presence_of(:city_town).with_message("Please enter a city or town")
    should validate_length_of(:city_town).is_at_most(50).with_message("50 characters maximum")
  end
end
