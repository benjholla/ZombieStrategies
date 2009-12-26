class StoresController < ApplicationController
  # GET /stores
  # GET /stores.xml
  def index
    
    # just returns all stores, use this to turn off server side filtering
    #@stores = Store.all  
    
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
    #  @stores = Store.find :all,
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
      @stores = Store.find(:all,
            :select=>"lat, lng, #{distance_sql} as distance",
            :conditions=>['lng > ? AND lng < ? AND lat <= ? AND lat >= ?',sw[1],ne[1],ne[0],sw[0]],
            :order => 'distance asc',
            :limit => 20)
    
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @stores }
        format.js {render :json => @stores.to_json(:include => {:items => {}}) } 
      end
    end
  end

  # GET /stores/1
  # GET /stores/1.xml
  def show
    @store = Store.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store }
      format.js {render :json => @store.to_json(:include => {:items => {}}) } 
    end
  end

  # GET /stores/new
  # GET /stores/new.xml
  def new
    @store = Store.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store }
    end
  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
  end

  # POST /stores
  # POST /stores.xml
  def create
      @store = Store.new(params[:store])
      @store.save
      @store.items = params[:store][:items]
      respond_to do |format|
        if @store.save
          flash[:notice] = 'Store was successfully created.'
          format.html { redirect_to(@store) }
          format.xml { render :xml => @store, :status => :created, :location => @store }
          format.js {
            render :json => {:success=>true,:content=>'<div><strong>Store: </strong>' + @store.store.to_str + '</div>',:id=>@store.id.to_s}
          }
        else
          format.html { render :action => "new" }
          format.xml { render :xml => @store.errors, :status => :unprocessable_entity }
          format.js do
            render :json => {:success=>false,:content=>"Could not save the store"}
          end
        end
      end
    end

  # PUT /stores/1
  # PUT /stores/1.xml
  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        flash[:notice] = 'Store was successfully updated.'
        format.html { redirect_to(@store) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @store.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.xml
  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to(stores_url) }
      format.xml  { head :ok }
    end
  end
  
end