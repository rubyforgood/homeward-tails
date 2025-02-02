class ValidateAddForeignKeyToPeopleForUser < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :people, :users
  end
end
