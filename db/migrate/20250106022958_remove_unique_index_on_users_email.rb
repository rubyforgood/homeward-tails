class RemoveUniqueIndexOnUsersEmail < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
      remove_index :users, name: "index_users_on_email"
      add_index :users, :email, algorithm: :concurrently
  end
end
