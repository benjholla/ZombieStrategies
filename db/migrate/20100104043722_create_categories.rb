class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :location_profile_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
