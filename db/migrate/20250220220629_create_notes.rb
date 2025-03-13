class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.text :notes
      t.references :notable, polymorphic: true, null: false
      t.references :organization, null: false, foreign_key: true
      t.timestamps
    end
  end
end
