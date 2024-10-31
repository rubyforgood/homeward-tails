class AddApplicationPausedNotNullConstraintToPets < ActiveRecord::Migration[7.2]
  def change
    # Add NOT NULL constraint to application_paused column and update any current NULL values to false
    safety_assured do
      change_column_null :pets, :application_paused, false, false
    end
  end
end
