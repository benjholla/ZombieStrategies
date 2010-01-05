class CreateProductLocationProfileMemberships < ActiveRecord::Migration
  def self.up
    create_table :product_location_profile_memberships do |t|
      t.integer :product_id
      t.integer :location_profile_id
      t.datetime :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :product_location_profile_memberships
  end
end
