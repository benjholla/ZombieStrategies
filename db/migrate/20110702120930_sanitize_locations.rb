class SanitizeLocations < ActiveRecord::Migration
  puts ''
  puts 'Sanitizing Locations...'
  puts ''

  i = 1
  Location.find_each(:batch_size => 1, :start => i) do |location|
    categories = location.category_ids.uniq
    categories = categories.sort
    location.category_ids = nil
    location.category_ids = categories
    
    items = location.item_ids.uniq
    items = items.sort
    location.item_ids = nil
    location.item_ids = items

    if (location.save)
      puts i.to_s + ' - Updated ' + location.name + ', ' + location.lat.to_s + ', ' + location.lng.to_s
    else
      puts i.to_s + ' - Failed to update ' + location.name + ', ' + location.lat.to_s + ', ' + location.lng.to_s
    end
    i = i + 1
  end

  puts ''
  puts 'Finished sanitizing ' + Location.all.count.to_s + ' locations.'
  puts ''
end
