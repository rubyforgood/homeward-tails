class ChangeAdopterFosterAccountNullOnAdopterApplications < ActiveRecord::Migration[7.1]
  def change
    if index_exists?(:adopter_applications, :adopter_foster_account_id)
      remove_index :adopter_applications, column: [:adopter_foster_account_id], name: :index_adopter_applications_on_adopter_foster_account_id
    end
    if column_exists?(:adopter_applications, :adopter_foster_account_id)
      change_column_null(:adopter_applications, :adopter_foster_account_id, true)
    end
  end
end
