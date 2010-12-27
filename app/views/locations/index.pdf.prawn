pdf.image("#{RAILS_ROOT}/public/images/title.png")
pdf.move_down(60)

pdf.text "#{@map}"
pdf.move_down(10)

stream = Hash.new
stream[:pic_google_map]="#{@map}"
pdf.image open(stream[:pic_google_map]), :width => 550, :height => 300, :position => :center
pdf.move_down(20)

table_content = @locations.map do |location|
	[
		location.location_profile.name,
		location.lat,
		location.lng
	]
end

pdf.table table_content, :border_style => :grid,
	:row_colors => ["FFFFFF", "DDDDDD"],
	:headers => ["Location Type", "Latitude", "Longitude"],
	:align => {0 => :left, 1 => :right, 2 => :right}

pdf.font_size 12
pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom], :width => 200, :height => 20) do
pdf.text "Generated by ZombieStrategies.com"
end

pdf.font_size 14
pdf.bounding_box([pdf.bounds.right - 50, pdf.bounds.bottom], :width => 60, :height => 20) do
pagecount = pdf.page_count
pdf.text "Page #{pagecount}"
end