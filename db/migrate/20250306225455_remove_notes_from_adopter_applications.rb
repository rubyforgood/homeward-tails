class RemoveNotesFromAdopterApplications < ActiveRecord::Migration[8.0]
  def change
    safety_assured { remove_column :adopter_applications, :notes, :text }
  end
end
