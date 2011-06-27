class CreateCategoryLocationProfileMemberships < ActiveRecord::Migration
  def self.up
    create_table :category_location_profile_memberships do |t|
      t.integer :category_id
      t.integer :location_profile_id
      t.datetime :created_at
      t.timestamps
    end
  end

  def self.down
    drop_table :category_location_profile_memberships
  end
end
