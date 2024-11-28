class AddLocatableToLocations < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_reference :locations, :locatable, polymorphic: true, null: true, index: {algorithm: :concurrently}
  end
end
