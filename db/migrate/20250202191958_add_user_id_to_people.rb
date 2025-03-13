class AddUserIdToPeople < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!
  def change
    add_reference :people, :user, null: true, index: {algorithm: :concurrently}
  end
end
