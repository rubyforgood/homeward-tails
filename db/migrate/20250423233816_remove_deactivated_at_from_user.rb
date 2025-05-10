class RemoveDeactivatedAtFromUser < ActiveRecord::Migration[8.0]
  def change
    safety_assured { remove_column :users, :deactivated_at, :datetime }
  end
end
