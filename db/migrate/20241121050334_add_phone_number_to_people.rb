class AddPhoneNumberToPeople < ActiveRecord::Migration[7.2]
  def change
    add_column :people, :phone_number, :string, limit: 15

    safety_assured do
      execute <<-SQL
      ALTER TABLE people
      ADD CONSTRAINT phone_number_valid_e164 CHECK (phone_number ~ '^[+]?[0-9]*$');
      SQL
    end
  end
end
