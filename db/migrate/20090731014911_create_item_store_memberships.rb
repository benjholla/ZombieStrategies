class CreateItemStoreMemberships < ActiveRecord::Migration
  def self.up
    create_table :item_store_memberships do |t|
      t.integer :store_id
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :item_store_memberships
  end
end
