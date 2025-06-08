class DropRolesAndUsersRoles < ActiveRecord::Migration[8.0]
  def change
    drop_table :users_roles
    drop_table :roles
  end
end
