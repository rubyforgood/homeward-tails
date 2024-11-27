class BackfillLocatableForLocations < ActiveRecord::Migration[7.2]
  def up
    # All locatables were previously organizations
    Location.find_each do |location|
      location.update!(
        locatable_type: "Organization",
        locatable_id: location.organization_id
      )
    end

    safety_assured do
      change_column_null :locations, :locatable_id, false
      change_column_null :locations, :locatable_type, false
    end
  end

  def down
    Location.find_each do |location|
      location.update!(organization_id: location.locatable_id)
    end
  end
end
