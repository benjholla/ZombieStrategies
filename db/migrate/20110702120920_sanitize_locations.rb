class SanitizeLocations < ActiveRecord::Migration
  puts 'Sanitizing Locations...'
  puts ''

  Location.all.each do |location|
    location.category_ids = location.category_ids.uniq
    location.item_ids = location.item_ids.uniq
    location.save
  end

  puts 'Finished sanitizing ' + Location.all.count + ' locations.'
  puts ''
end
