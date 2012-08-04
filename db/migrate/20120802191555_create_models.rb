class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.references :parent
      t.integer :parent_points, :default => 300
      t.date :model_date

      t.timestamps
    end
    add_index :models, :parent_id
  end
end
