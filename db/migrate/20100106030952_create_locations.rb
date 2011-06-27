class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer  :location_profile_id
      t.integer  :location_classification_id
      t.column   :lat, :decimal, :precision => 15, :scale => 10
      t.column   :lng, :decimal, :precision => 15, :scale => 10
      t.string   :name
      t.string   :address
      t.string   :city
      t.string   :state_providence
      t.string   :zip
      t.string   :country
      t.text     :info
      t.text     :modification_log
      t.text     :audit_log
      t.boolean  :flagged, :default => false
      t.string   :flagged_by
      t.datetime :validated
      t.string   :validated_by
      t.datetime :created
      t.string   :created_by
      t.datetime :modified
      t.string   :modified_by
    end
  end

  def self.down
    drop_table :locations
  end
end
