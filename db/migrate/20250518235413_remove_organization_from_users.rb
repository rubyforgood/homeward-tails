class RemoveOrganizationFromUsers < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      remove_reference :users, :organization
    end
  end
end
