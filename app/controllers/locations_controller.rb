class LocationsController < ApplicationController
  
  # before_filter :admin_login_required, :only => [:flagged, :unflag]
  
  before_filter :admin_login_required, :except => [:index, :show]
  
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
      lat,lng = params[:ll].split(',').collect{|e|e.to_f}
      ne = params[:ne].split(',').collect{|e|e.to_f}  
      sw = params[:sw].split(',').collect{|e|e.to_f}
      
      # parse out parameters individually, for intance variables in the view
      @home_lat = lat
      @home_lng = lng

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
         format.pdf {render :layout => false} # index.pdf.prawn
         format.xml  { render :xml => @locations }
         format.count  { render :text => @locations.count }
         format.js { render :json => @locations.to_json(:only => {:id => {}, :lat => {}, :lng => {}, :distance => {}}, :include => {:location_profile => {:only => :name}}) } 
       end
    elsif(params[:ll]!=nil && params[:results]!=nil)
      lat,lng=params[:ll].split(',').collect{|e|e.to_f}
      results = params[:results].to_i
      
      if(results > 50)
        results = 50
      end
      
      if(results < 1)
        results = 1
      end
      
      # parse out parameters individually, for intance variables in the view
      @home_lat = lat
      @home_lng = lng

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
            :order => 'distance asc',
            :limit => results)
    
      respond_to do |format|
        format.html { render :text => "Request Denied" }
        format.pdf {render :layout => false} # index.pdf.prawn
        format.xml  { render :xml => @locations }
        format.js { render :json => @locations.to_json(:only => {:id => {}, :lat => {}, :lng => {}, :distance => {}}, :include => {:location_profile => {:only => :name}}) } 
      end
    else
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
      format.js { render :json => @location.to_json(:include => {:location_profile => {}, :categories => {}, :items => {}}) }
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
    
    if(params[:authentication]!=nil && params[:authentication][:username]!=nil && params[:authentication][:password]!=nil)
      user = User.authenticate(params[:authentication][:username], params[:authentication][:password])
      if user
        self.current_user = user
      end
    end
    
    @location = Location.new(params[:location])
    
    if authorized?
      @location.created_by = self.current_user.login
      @location.modified_by = self.current_user.login
      @location.validated_by = self.current_user.login
    else
      @location.created_by = 'anonymous'
      @location.modified_by = 'anonymous'
      @location.validated_by = 'anonymous'
    end
    
    @location.validated = Time.now
    @location.created = Time.now
    @location.modified = Time.now

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

    if(params[:location] && params[:location][:validated])
      params[:location][:validated] = @location.validated
    end
    
    if(params[:location] && params[:location][:validated_by])
      params[:location][:validated_by] = @location.validated_by
    end
    
    if(params[:location] && params[:location][:created])
      params[:location][:created] = @location.created
    end
    
    if(params[:location] && params[:location][:created_by])
      params[:location][:created_by] = @location.created_by
    end
    
    if(params[:authentication]!=nil && params[:authentication][:username]!=nil && params[:authentication][:password]!=nil)
      user = User.authenticate(params[:authentication][:username], params[:authentication][:password])
      if user
        self.current_user = user
      end
    end
    
    if(params[:location] && params[:location][:modified])
      params[:location][:modified] = Time.now
    else
      @location.modified = Time.now
    end
    
    if authorized?
      @location.modified_by = self.current_user.login
    else
      @location.modified_by = 'anonymous'
    end

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
  
  # GET /locations/1/validate
  def validate
    @location = Location.find(params[:id])

    @location.validated = Time.now
    
    if(params[:authentication]!=nil && params[:authentication][:username]!=nil && params[:authentication][:password]!=nil)
      user = User.authenticate(params[:authentication][:username], params[:authentication][:password])
      if user
        self.current_user = user
      end
    end
    
    if authorized?
      @location.validated_by = self.current_user.login
    else
      @location.validated_by = 'anonymous'
    end

    respond_to do |format|
      if @location.save
        format.js {
          render :json => {:success=>true, :validated => @location.validated, :updated => @location.modified}
        }
        format.xml {
          render :xml => {:success=>true, :validated => @location.validated, :updated => @location.modified}
        }
       else
        format.js {
          render :json => {:success=>false, :validated => @location.validated, :updated => @location.modified}
        }
        format.xml {
          render :xml => {:success=>false, :validated => @location.validated, :updated => @location.modified}
        }
      end
    end
  end

  # GET /locations/1/flag
  def flag
    @location = Location.find(params[:id])

    @location.flagged = true
    
    if(params[:authentication]!=nil && params[:authentication][:username]!=nil && params[:authentication][:password]!=nil)
      user = User.authenticate(params[:authentication][:username], params[:authentication][:password])
      if user
        self.current_user = user
      end
    end
    
    if authorized?
      @location.flagged_by = self.current_user.login
    else
      @location.flagged_by = 'anonymous'
    end

    respond_to do |format|
      if @location.save
         format.js {
           render :json => {:success=>true, :flagged => @location.flagged}
         }
         format.xml {
            render :xml => {:success=>true, :flagged => @location.flagged}
          }
       else
        format.js {
          render :json => {:success=>false, :flagged => @location.flagged}
        }
        format.xml {
          render :xml => {:success=>false, :flagged => @location.flagged}
        }
      end
    end
  end
  
  # GET /locations/1/flag
  def unflag
    @location = Location.find(params[:id])

    @location.flagged = false
    @location.flagged_by = nil

    respond_to do |format|
      if @location.save
        format.js {
          render :json => {:success=>true, :flagged => @location.flagged}
        }
        format.xml {
          render :xml => {:success=>true, :flagged => @location.flagged}
        }
      else
        format.js {
          render :json => {:success=>false, :flagged => @location.flagged}
        }
        format.xml {
          render :xml => {:success=>false, :flagged => @location.flagged}
        }
      end
    end
  end
  
  def flagged
    @locations = Location.find(:all, :select=>"id, name, flagged_by", :conditions => "flagged = true")

    respond_to do |format|
      format.xml  { render :xml => @locations }
      format.js { render :json => @locations } 
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
