############################    Constants     ###########################

@map_width = 500
@map_height = 300

############################  Helper Methods  ###########################

# classifies x pixel value by column letter
def get_map_letter_index(x_value)
	if x_value >= 0 && x_value <= 50
		return 'A'
	elsif x_value >= 50 && x_value <= 100
		return 'B'
	elsif x_value >= 100 && x_value <= 150
		return 'C'
	elsif x_value >= 150 && x_value <= 200
		return 'D'
	elsif x_value >= 200 && x_value <= 250
		return 'E'
	elsif x_value >= 250 && x_value <= 300
		return 'F'
	elsif x_value >= 300 && x_value <= 350
		return 'G'
	elsif x_value >= 350 && x_value <= 400
		return 'H'
	elsif x_value >= 400 && x_value <= 450
		return 'I'
	elsif x_value >= 450 && x_value <= 500
		return 'J'		
	else
		return '?'
	end
end

# classifies y pixel value by row number
def get_map_number_index(y_value)
	if y_value >= 0 && y_value <= 50
		return '1'
	elsif y_value >= 50 && y_value <= 100
		return '2'
	elsif y_value >= 100 && y_value <= 150
		return '3'
	elsif y_value >= 150 && y_value <= 200
		return '4'
	elsif y_value >= 200 && y_value <= 250
		return '5'
	elsif y_value >= 250 && y_value <= 300
		return '6'		
	else
		return '?'
	end
end

# calculates the distance between two points
# change the return type to change units
def haversine_distance(lat1, lon1, lat2, lon2)
    rad_per_degree = 0.017453293  #  Math::PI/180
	 
    # the great circle distance d will be in whatever units R is in
	 
    rmiles = 3956           # radius of the great circle in miles
    rkm = 6371              # radius in kilometers...some algorithms use 6367
    rfeet = rmiles * 5282   # radius in feet
    rmeters = rkm * 1000    # radius in meters

 	dlon = lon2 - lon1
	dlat = lat2 - lat1
	 
	dlon_rad = dlon * rad_per_degree
	dlat_rad = dlat * rad_per_degree
	 
	lat1_rad = lat1 * rad_per_degree
	lon1_rad = lon1 * rad_per_degree
	 
	lat2_rad = lat2 * rad_per_degree
	lon2_rad = lon2 * rad_per_degree
   
    puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"
	 
	a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
	c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))
	 
	dMi = rmiles * c          # delta between the two points in miles
	dKm = rkm * c             # delta in kilometers
	dFeet = rfeet * c         # delta in feet
	dMeters = rmeters * c     # delta in meters
	 
	return dMi
end

# References 
# http://www.appelsiini.net/2008/6/clickable-markers-with-google-static-maps
# http://svn.appelsiini.net/svn/javascript/trunk/google_maps_nojs/Google/Maps.php

def world_x_to_lng(x)
	offset = 268435456 
	radius = offset / Math::PI
	return ((x.round - offset) / radius) * 180/ Math::PI  
end

def world_y_to_lat(y)
	offset = 268435456
	radius = offset / Math::PI       
	return (Math::PI / 2 - 2 * Math::atan(Math::exp((y.round - offset) / radius))) * 180 / Math::PI 
end


def lng_to_world_x(lng_value)
	offset = 268435456
	radius = offset / Math::PI
	return (offset + radius * lng_value * Math::PI / 180).round
end

def lat_to_world_y(lat_value)
	offset = 268435456 
	radius = offset / Math::PI 
	return (offset - radius * Math::log((1 + Math::sin(lat_value * Math::PI / 180)) / (1 - Math::sin(lat_value * Math::PI / 180))) / 2).round
end

def lng_to_x(lng_value, center_x, center_offset_x, zoom)
	# convert longitude to world pixel x coordinate
	target_x = lng_to_world_x(lng_value)
	# calculate difference between target_x and map center x
	# coordinates and convert difference to match current zoom level
	delta_x  = (target_x - center_x) >> (21 - zoom)
	# add above difference to center pixel coordinates in image
	marker_x = center_offset_x + delta_x
	return marker_x
end

def lat_to_y(lat_value, center_y, center_offset_y, zoom)
	# convert latitude and longitude to world pixel y coordinate
	target_y = lat_to_world_y(lat_value)
	# calculate difference between target_y and map center y
	# coordinates and convert difference to match current zoom level
	delta_y  = (target_y - center_y) >> (21 - zoom)
	# add above difference to center pixel coordinates in image
	marker_y = center_offset_y + delta_y
	return marker_y
end

# References
# https://github.com/tuupola/php_google_maps/blob/master/Google/Maps/Static.php

@bounds = Hash.new
# This will find the smallest latitude/longitude for the top left 
# point and the largest latitude/longitude for the bottom right point.
def define_bounds
	minLat = 900
	minLng = 900
	maxLat = -900
	maxLng = -900
	
	@locations.map do |location|
		if location.lat < minLat
			minLat = location.lat
		end
		if location.lng < minLng
			minLng = location.lng
		end
		if location.lat > maxLat
			maxLat = location.lat
		end
		if location.lng > maxLng
			maxLng = location.lng
		end
	end
	@bounds["n"] = maxLat
	@bounds["s"] = minLat
	@bounds["e"] = maxLng
	@bounds["w"] = minLng
end

# References
# http://blog.whatclinic.com/2008/10/how-to-make-google-static-maps-interactive.html
# http://blog.whatclinic.com/2008/10/how-to-make-google-static-maps-interactive-part-2.html

def atanh(rad)
	return (Math::log(((1 + rad) / (1 - rad))) / Math::log(Math::E) / 2)
end

def get_zoom(span)
	zoomlevel = (180.00 / span) * (@map_width / 256.00)
	zoomlevel = Math::log(zoomlevel) / Math::log(2)
	return zoomlevel.floor
end

############################  Initialization Code  ###########################

# calculate the bounds
define_bounds

# zoom is decided by the max span of longitude and an adjusted latitude span
# the relationship between the latitude span and the longitude span is divided by cos
# Note: logx(y) = log(y)/log(x) 
atanhsinO = atanh(Math::sin(@bounds["n"] * Math::PI / 180.00))
atanhsinD = atanh(Math::sin(@bounds["s"] * Math::PI / 180.00))
atanhCenter = (atanhsinD + atanhsinO) / 2
radianOfCenterLatitude = Math::atan(Math::sinh(atanhCenter))
latitude_span = (@bounds["n"]-@bounds["s"]) / Math::cos(radianOfCenterLatitude)
longitude_span = @bounds["e"]-@bounds["w"]
zoom = get_zoom([latitude_span, longitude_span].max) + 1

# calculate center as pixel coordinates in world map
center_x = lng_to_world_x(@home_lng) 
center_y = lat_to_world_y(@home_lat)

# calculate center as pixel coordinates in image
center_offset_x = (@map_width / 2).round
center_offset_y = (@map_height / 2).round

############################  Begin PDF Generation ############################

pdf.text "zoom = #{zoom}\n"
#pdf.text "#{@map}"
pdf.move_down(30)

stream = Hash.new
stream[:pic_google_map]="#{@map}"
pdf.image open(stream[:pic_google_map]), :width => 500, :height => 300, :position => :center
pdf.move_up(320)
pdf.image("#{RAILS_ROOT}/public/images/pdf/map-guide-markers-with-grid.png", :width => 540, :height => 320, :position => :center)
pdf.move_down(20)

stream[:pic_google_map]="#{@map}&zoom=#{zoom}"
pdf.image open(stream[:pic_google_map]), :width => 500, :height => 300, :position => :center
pdf.move_up(320)
pdf.image("#{RAILS_ROOT}/public/images/pdf/map-guide-markers-with-grid.png", :width => 540, :height => 320, :position => :center)
pdf.move_down(20)

table_content = @locations.map do |location|
	[
		location.location_profile.name,
		format("%0.6f", haversine_distance(@home_lat, @home_lng, location.lat, location.lng)),
		location.lat,
		location.lng,
		"(#{lng_to_x(location.lng, center_x, center_offset_x, zoom)}, #{lat_to_y(location.lat, center_y, center_offset_y, zoom)})",
		"#{get_map_letter_index(lng_to_x(location.lng, center_x, center_offset_x, zoom))}#{get_map_number_index(lat_to_y(location.lat, center_y, center_offset_y, zoom))}"
	]
end

pdf.table table_content, :border_style => :grid,
	:row_colors => ["FFFFFF", "DDDDDD"],
	:headers => ["Location Type", "Distance Miles", "Latitude", "Longitude", "Pixel Index", "Map Index"],
	:align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :center, 5 => :center}
	
