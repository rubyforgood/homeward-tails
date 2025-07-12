class AddActiveColumnToOrganizations < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      add_column :organizations, :active, :boolean, default: true, null: false
      add_index :organizations, :active
    end
  end
end
