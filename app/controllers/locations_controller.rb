class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.xml
  def index
    # just returns all locations, use this to turn off server side filtering
    #@locations = Location.all  
    
    # server side filtering within bounds only
    #if(params[:ne]!=nil && params[:sw]!=nil)
    #  ne = params[:ne].split(',').collect{|e|e.to_f}
    #  sw = params[:sw].split(',').collect{|e|e.to_f}
    #
    #  # if the NE longitude is less than the SW longitude
    #  # it means we are split over the meridian
    #  if ne[1] > sw[1]
    #    conditions = 'lng > ? AND lng < ? AND lat <= ? AND lat >= ?'
    #  else
    #    conditions = '(lng >= ? OR lng < ?) AND lat <= ? AND lat >= ?'
    #  end
    #
    #  @locations = Location.find :all,
    #    :conditions => [conditions,sw[1],ne[1],ne[0],sw[0]]
    
    # server side filtering within bounds and x closest points to the given lat/lng point
    if(params[:ne]!=nil && params[:sw]!=nil && params[:ll]!=nil)
      lat,lng=params[:ll].split(',').collect{|e|e.to_f}
      ne = params[:ne].split(',').collect{|e|e.to_f}  
      sw = params[:sw].split(',').collect{|e|e.to_f}

      #convert to radians
      lat_radians=(lat / 180) * Math::PI
      lng_radians=(lng / 180) * Math::PI
      distance_sql=<<-SQL_END
      (acos(cos(#{lat_radians})*cos(#{lng_radians})*cos(radians(lat))*cos(radians(lng)) +
    cos(#{lat_radians})*sin(#{lng_radians})*cos(radians(lat))*sin(radians(lng)) +
    sin(#{lat_radians})*sin(radians(lat))) * 3693)
      SQL_END

      # change the :limit => x to be the number of closest locations to return per query 
      @locations = Location.find(:all,
            :select=>"*, #{distance_sql} as distance",
            :conditions=>['lng > ? AND lng < ? AND lat <= ? AND lat >= ?',sw[1],ne[1],ne[0],sw[0]],
            :order => 'distance asc',
            :limit => 35)
    
       respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @locations }
         format.count  { render :text => @locations.count }
         format.js { render :json => @locations.to_json(:only => {:id => {}, :lat => {}, :lng => {}, :distance => {}}, :include => {:location_profile => {:only => :name}}) } 
       end
    elsif
      respond_to do |format|
        format.html # index.html.erb
        format.count  { render :text => Location.all.count }
      end
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
      format.js { render :json => @location.to_json(:include => {:location_profile => {}, :categories => {}, :products => {}}) }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new
    
    if(params[:lat]!=nil && params[:lng]!=nil)
      @location.lat = params[:lat].collect{|e|e.to_f}
      @location.lng = params[:lng].collect{|e|e.to_f}
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(@location) }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
        format.js {
          render :json => {:success=>true,:id=>@location.id.to_s}
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
        format.js do
          render :json => {:success=>false}
        end
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
         format.html { redirect_to(locations_path) }
         format.xml  { head :ok }
         format.js {
          render :json => {:success=>true,:id=>@location.id.to_s}
         }
       else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
        format.js {
          render :json => {:success=>false}
        }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
end
