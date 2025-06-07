class RemoveNameFieldsFromUsers < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      remove_column :users, :first_name, :string
      remove_column :users, :last_name, :string
    end
  end
end
