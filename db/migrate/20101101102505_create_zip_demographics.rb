class CreateZipDemographics < ActiveRecord::Migration
  def self.up
    create_table :zip_demographics do |t|
      t.string  :source
      t.string  :zip
      t.string  :state_name
      t.string  :state_abbreviation
      t.integer :total_population
      t.integer :total_housing_units
      t.column  :land_area_square_miles, :decimal, :precision => 15, :scale => 10
      t.column  :water_area_square_miles, :decimal, :precision => 15, :scale => 10
      t.column  :population_density_square_miles, :decimal, :precision => 15, :scale => 10
      t.column  :lat, :decimal, :precision => 15, :scale => 10
      t.column  :lng, :decimal, :precision => 15, :scale => 10
      t.timestamps
    end  
  end

 def self.down
    drop_table :zip_demographics
  end
end