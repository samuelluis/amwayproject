class CreateMemberModels < ActiveRecord::Migration
  def change
    create_table :member_models do |t|
      t.references :member
      t.references :model
      t.integer :points, :default => 300

      t.timestamps
    end
    add_index :member_models, :member_id
    add_index :member_models, :model_id
  end
end
