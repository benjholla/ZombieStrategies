# calculates the distance between two points
# change the return type to change units
def haversine_distance(lat1, lon1, lat2, lon2)
    # PI = 3.1415926535
    rad_per_degree = 0.017453293  #  PI/180
	 
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
	@bounds["n"] = minLng
	@bounds["e"] = minLat
	@bounds["s"] = maxLng
	@bounds["w"] = maxLat
end

@map_size_width = 256
def get_zoom(span)
	zoom = (180.00 / span) * (@map_size_width / 256.00)
	zoom = Math::log(zoom) / Math::log(2)
	return zoom.floor
end

def atanh(rad)
	return (Math::log(((1 + rad) / (1 - rad))) / Math::log(Math::E) / 2)
end

def get_x_pixel_value(currentLatitude, currentLongitude, oneDegree, radianLength, centreY)
	pixelLongitude = (currentLongitude - @map_center_lng) * oneDegree
	pixelLatitudeRadians = @map_center_lng * Math::PI / 180.00
	localAtanh = atanh(Math::sin(pixelLatitudeRadians))
	realPixelLatitude = radianLength * localAtanh
	pixelLatitude = centreY - realPixelLatitude # convert from our virtual map to the displayed portion
	pixelLongitude = pixelLongitude + (@map_size_width / 2)
	pixelLatitude = pixelLatitude + (@map_size_width / 2)
	x = pixelLongitude.floor
	y = pixelLatitude.floor
	return x
end

def get_y_pixel_value(currentLatitude, currentLongitude, oneDegree, radianLength, centreY)
	pixelLongitude = (currentLongitude - @map_center_lng) * oneDegree
	pixelLatitudeRadians = @map_center_lng * Math::PI / 180.00
	localAtanh = atanh(Math::sin(pixelLatitudeRadians))
	realPixelLatitude = radianLength * localAtanh
	pixelLatitude = centreY - realPixelLatitude # convert from our virtual map to the displayed portion
	pixelLongitude = pixelLongitude + (@map_size_width / 2)
	pixelLatitude = pixelLatitude + (@map_size_width / 2)
	x = pixelLongitude.floor
	y = pixelLatitude.floor
	return y
end

############################  Initialization Code  ###########################

# calculate the bounds
define_bounds

# zoom is decided by the max span of longitude and an adjusted latitude span
# the relationship between the latitude span and the longitude span is /cos
# Note: logx(y) = log(y)/log(x) 
atanhsinO = atanh(Math::sin(@bounds["w"] * Math::PI / 180.00))
atanhsinD = atanh(Math::sin(@bounds["e"] * Math::PI / 180.00))
atanhCentre = (atanhsinD + atanhsinO) / 2
radianOfCentreLatitude = Math::atan(Math::sinh(atanhCentre))

latitude_span = (@bounds["w"]-@bounds["e"]) / Math::cos(radianOfCentreLatitude)
longitude_span = @bounds["s"]-@bounds["n"]

zoom = get_zoom([latitude_span, longitude_span].max) + 1

# create the x,y co-ordinates for the centre as they would appear on a map of the earth
power = 2 ** zoom
realWidth = 256 * power

# determine pixel size of one degree
oneDegree = realWidth / 360.00
radianLength = realWidth / (2.00 * Math::PI)

# determine the centre on our virtual map
centreY = radianLength * atanhCentre

############################  Begin PDF Generation ############################

pdf.image("#{RAILS_ROOT}/public/images/title.png")
pdf.move_down(60)

#pdf.text "#{@map}\n\n"
#pdf.text "north = #{@bounds['n']}\n"
#pdf.text "east = #{@bounds['e']}\n"
#pdf.text "south = #{@bounds['s']}\n"
#pdf.text "west = #{@bounds['w']}\n"
#pdf.text "latitude span = #{latitude_span}\n"
#pdf.text "longitude span = #{longitude_span}\n"
pdf.text "zoom = #{zoom}\n"
pdf.move_down(30)

stream = Hash.new
stream[:pic_google_map]="#{@map}"
pdf.image open(stream[:pic_google_map]), :width => 500, :height => 300, :position => :center
pdf.move_up(320)
pdf.image("#{RAILS_ROOT}/public/images/pdf/map-guide-markers-with-grid.png", :width => 540, :height => 320, :position => :center)

pdf.move_down(20)

table_content = @locations.map do |location|
	[
		location.location_profile.name,
		format("%0.6f", haversine_distance(@map_center_lat, @map_center_lng, location.lat, location.lng)),
		location.lat,
		location.lng,
		get_x_pixel_value(location.lat, location.lng, oneDegree, radianLength, centreY),
		get_y_pixel_value(location.lat, location.lng, oneDegree, radianLength, centreY)
	]
end

pdf.table table_content, :border_style => :grid,
	:row_colors => ["FFFFFF", "DDDDDD"],
	:headers => ["Location Type", "Distance Miles", "Latitude", "Longitude", "X", "Y"],
	:align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :center, 5 => :center}

pdf.font_size 12
pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom], :width => 200, :height => 20) do
pdf.text "Generated by ZombieStrategies.com"
end

pdf.font_size 14
pdf.bounding_box([pdf.bounds.right - 50, pdf.bounds.bottom], :width => 60, :height => 20) do
pagecount = pdf.page_count
pdf.text "Page #{pagecount}"
end