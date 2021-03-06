class CreateItemLocationMemberships < ActiveRecord::Migration
  def self.up
    create_table :item_location_memberships do |t|
      t.integer :item_id
      t.integer :location_id
      t.datetime :created_at
      t.timestamps
    end
  end

  def self.down
    drop_table :item_location_memberships
  end
end
