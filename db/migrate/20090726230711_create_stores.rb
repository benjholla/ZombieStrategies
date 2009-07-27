class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :store
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end