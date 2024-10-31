class DropStaffAccountsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :staff_accounts
  end
end
