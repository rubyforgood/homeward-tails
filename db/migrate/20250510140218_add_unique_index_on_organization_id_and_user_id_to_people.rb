class AddUniqueIndexOnOrganizationIdAndUserIdToPeople < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!
  def change
    add_index :people, [:organization_id, :user_id],
      unique: true,
      where: "user_id IS NOT NULL",
      algorithm: :concurrently
  end
end
