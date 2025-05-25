class AddForeignKeyToPeopleForUser < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :people, :users, null: true, validate: false
  end
end
