class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :code
      t.integer :points, :default => 300
      t.references :parent
      t.references :person
      t.references :user

      t.timestamps
    end
    add_index :members, :parent_id
    add_index :members, :person_id
    add_index :members, :user_id
  end
end
