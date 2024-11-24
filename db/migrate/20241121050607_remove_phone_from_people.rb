class RemovePhoneFromPeople < ActiveRecord::Migration[7.2]
  def change
    safety_assured { remove_column :people, :phone, :string }
  end
end
