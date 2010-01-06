class CreateProductLocationMemberships < ActiveRecord::Migration
  def self.up
    create_table :product_location_memberships do |t|
      t.integer :product_id
      t.integer :location_id
      t.datetime :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :product_location_memberships
  end
end
