class UpdateAdopterApplicationsToBelongToPerson < ActiveRecord::Migration[7.2]
  def change
    safety_assured do
      remove_foreign_key :adopter_applications, :form_submissions
      remove_index :adopter_applications, column: :form_submission_id
      remove_index :adopter_applications, name: "index_adopter_applications_on_pet_id_and_form_submission_id"
      remove_column :adopter_applications, :form_submission_id, :bigint

      add_reference :adopter_applications, :person, null: false, foreign_key: true
    end
  end
end
