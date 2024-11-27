class RemoveOrganizationFromLocations < ActiveRecord::Migration[7.2]
  def change
    safety_assured do
      remove_reference :locations, :organization, foreign_key: true
    end
  end
end
