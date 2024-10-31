class AddCustomerNameColumnToOrganizations < ActiveRecord::Migration[7.2]
  def up
    add_column :organizations, :requester_name, :string
  end

  def down
    remove_column :organizations, :requester_name
  end
end
