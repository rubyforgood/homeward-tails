class RequirePersonIdForUsers < ActiveRecord::Migration[7.2]
  def change
    safety_assured do
      change_column_null :users, :person_id, false
    end
  end
end
