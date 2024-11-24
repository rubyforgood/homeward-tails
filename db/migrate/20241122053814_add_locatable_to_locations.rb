class AddLocatableToLocations < ActiveRecord::Migration[7.2]
  def change
    safety_assured do
      remove_reference :locations, :organization, foreign_key: true

      add_reference :locations, :locatable, polymorphic: true, null: false, index: true
    end
  end
end
