class RemovePersonFromUser < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      if foreign_key_exists?(:users, column: :person_id)
        remove_foreign_key :users, column: :person_id
      end
      remove_column :users, :person_id
    end
  end
end
