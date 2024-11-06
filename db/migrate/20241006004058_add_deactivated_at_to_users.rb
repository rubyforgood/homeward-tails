class AddDeactivatedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :deactivated_at, :datetime
  end
end
