class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :code
      t.references :parent
      t.references :person

      t.timestamps
    end
    add_index :members, :parent_id
    add_index :members, :person_id
  end
end
