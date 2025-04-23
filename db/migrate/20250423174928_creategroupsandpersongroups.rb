class Creategroupsandpersongroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.integer :name, null: false
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end

    create_table :person_groups do |t|
      t.references :person, null: false, foreign_key: {on_delete: :cascade}
      t.references :group, null: false, foreign_key: true
      t.datetime :deactivated_at

      t.timestamps
    end

    add_index :groups, [:name, :organization_id], unique: true
    add_index :person_groups, [:person_id, :group_id], unique: true
  end
end
