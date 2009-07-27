class CreateTwitterComputations < ActiveRecord::Migration
  def self.up
    create_table :twitter_computations do |t|
      t.integer :twitter_trend_id
      t.float :rate
      t.integer :population
      t.integer :threat

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_computations
  end
end
