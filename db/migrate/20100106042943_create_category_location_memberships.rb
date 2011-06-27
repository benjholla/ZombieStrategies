class CreateCategoryLocationMemberships < ActiveRecord::Migration
  def self.up
    create_table :category_location_memberships do |t|
      t.integer :category_id
      t.integer :location_id
      t.datetime :created_at
      t.timestamps
    end
  end

  def self.down
    drop_table :category_location_memberships
  end
end
