class CreateTwitterTrends < ActiveRecord::Migration
  def self.up
    create_table :twitter_trends do |t|
      t.string :name
      t.string :search
      t.float :threshold
      t.integer :resolution
      t.datetime :scheduled_update

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_trends
  end
end
