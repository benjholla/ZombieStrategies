class CreateLocationProfiles < ActiveRecord::Migration
  def self.up
    create_table :location_profiles do |t|
      t.string :name
      t.integer  :location_classification_id
      t.timestamps
    end
  end

  def self.down
    drop_table :location_profiles
  end
end
