class AddCustomerNameColumnToOrganizations < ActiveRecord::Migration[7.2]
  def up
    add_column :organizations, :organization_requester_name, :string
  end

  def down
    remove_column :organizations, :organization_requester_name
  end
end
