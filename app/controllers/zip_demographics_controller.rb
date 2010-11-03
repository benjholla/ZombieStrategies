class ZipDemographicsController < ApplicationController
  # GET /zip_demographics
  # GET /zip_demographics.xml
  def index
    
    # just return all entries, no server side filtering
    #@zip_demographics = ZipDemographic.all
    
    # for US,Canada,Mexico,Puerto Rico searches use
    # ne=61.100789,-33.925781 and sw=7.362467,-152.578125
    # use resuts parameter to define the number of returned results
    # results=2, returns up to two results
    # i.e. http://127.0.0.1:3000/zip_demographics.js?ne=61.100789,-33.925781&sw=7.362467,-152.578125&ll=42.023341,-93.625622&results=2
    
    # server side filtering within bounds and x closest points to the given lat/lng point
    if(params[:source]!=nil && params[:ne]!=nil && params[:sw]!=nil && params[:ll]!=nil && params[:results]!=nil && params[:results].to_i<=50)
       lat,lng=params[:ll].split(',').collect{|e|e.to_f}
       ne = params[:ne].split(',').collect{|e|e.to_f}  
       sw = params[:sw].split(',').collect{|e|e.to_f}
       results = params[:results].to_i

       # convert to radians
       lat_radians=(lat / 180) * Math::PI
       lng_radians=(lng / 180) * Math::PI
       distance_sql=<<-SQL_END
          (acos(cos(#{lat_radians})*cos(#{lng_radians})*cos(radians(lat))*cos(radians(lng)) +
          cos(#{lat_radians})*sin(#{lng_radians})*cos(radians(lat))*sin(radians(lng)) +
          sin(#{lat_radians})*sin(radians(lat))) * 3693)
          SQL_END

       # change the :limit => x to be the number of closest locations to return per query 
      case ActiveRecord::Base.connection.adapter_name
         when 'SQLite'  
           @zip_demographics = ZipDemographic.find(:all,
                                                   :select=>"id, lat, lng, #{distance_sql} as distance",
                                                   :conditions=>['(lng > ? AND lng < ? AND lat <= ? AND lat >= ?) AND source LIKE %#{params[:source]}%',sw[1],ne[1],ne[0],sw[0]],
                                                   :order => 'distance asc',
                                                   :limit => results)
         when 'MySQL'
           @zip_demographics = ZipDemographic.find(:all,
                                                   :select=>"id, lat, lng, #{distance_sql} as distance",
                                                   :conditions=>['(lng > ? AND lng < ? AND lat <= ? AND lat >= ?) AND source LIKE %#{params[:source]}%',sw[1],ne[1],ne[0],sw[0]],
                                                   :order => 'distance asc',
                                                   :limit => results)
         when 'PostgreSQL'
           @zip_demographics = ZipDemographic.find(:all,
                                                   :select=>"id, lat, lng, #{distance_sql} as distance",
                                                   :conditions=>['(lng > ? AND lng < ? AND lat <= ? AND lat >= ?) AND source ILIKE %#{params[:source]}%',sw[1],ne[1],ne[0],sw[0]],
                                                   :order => 'distance asc',
                                                   :limit => results)
         else
           raise 'Unsupported DB adapter'
      end

    elsif(params[:source]!=nil && params[:ll]!=nil && params[:results]!=nil && params[:results].to_i<=50)
      lat,lng=params[:ll].split(',').collect{|e|e.to_f}
      results = params[:results].to_i

      # convert to radians
      lat_radians=(lat / 180) * Math::PI
      lng_radians=(lng / 180) * Math::PI
      distance_sql=<<-SQL_END
        (acos(cos(#{lat_radians})*cos(#{lng_radians})*cos(radians(lat))*cos(radians(lng)) +
        cos(#{lat_radians})*sin(#{lng_radians})*cos(radians(lat))*sin(radians(lng)) +
        sin(#{lat_radians})*sin(radians(lat))) * 3693)
        SQL_END

      # change the :limit => x to be the number of closest locations to return per query 
      case ActiveRecord::Base.connection.adapter_name
        when 'SQLite'  
          @zip_demographics = ZipDemographic.find(:all,
                                                  :select=>"id, lat, lng, #{distance_sql} as distance",
                                                  :order => 'distance asc',
                                                  :limit => results,
                                                  :conditions => ["source LIKE ?", "%#{params[:source]}%"])
        when 'MySQL'
          @zip_demographics = ZipDemographic.find(:all,
                                                  :select=>"id, lat, lng, #{distance_sql} as distance",
                                                  :order => 'distance asc',
                                                  :limit => results,
                                                  :conditions => ["source LIKE ?", "%#{params[:source]}%"])
        when 'PostgreSQL'
          @zip_demographics = ZipDemographic.find(:all,
                                                  :select=>"id, lat, lng, #{distance_sql} as distance",
                                                  :order => 'distance asc',
                                                  :limit => results,
                                                  :conditions => ["source ILIKE ?", "%#{params[:source]}%"])
        else
          raise 'Unsupported DB adapter'
      end
                                                
    elsif(params[:source]!=nil && params[:ll]!=nil)
      lat,lng=params[:ll].split(',').collect{|e|e.to_f}

      # convert to radians
      lat_radians=(lat / 180) * Math::PI
      lng_radians=(lng / 180) * Math::PI
      distance_sql=<<-SQL_END
        (acos(cos(#{lat_radians})*cos(#{lng_radians})*cos(radians(lat))*cos(radians(lng)) +
        cos(#{lat_radians})*sin(#{lng_radians})*cos(radians(lat))*sin(radians(lng)) +
        sin(#{lat_radians})*sin(radians(lat))) * 3693)
        SQL_END

      # change the :limit => x to be the number of closest locations to return per query 
      case ActiveRecord::Base.connection.adapter_name
        when 'SQLite'  
          @zip_demographics = ZipDemographic.find(:all,
                                                  :select=>"id, lat, lng, #{distance_sql} as distance",
                                                  :order => 'distance asc',
                                                  :limit => 1,
                                                  :conditions => ["source LIKE ?", "%#{params[:source]}%"])
        when 'MySQL'
          @zip_demographics = ZipDemographic.find(:all,
                                                  :select=>"id, lat, lng, #{distance_sql} as distance",
                                                  :order => 'distance asc',
                                                  :limit => 1,
                                                  :conditions => ["source LIKE ?", "%#{params[:source]}%"])
        when 'PostgreSQL'
          @zip_demographics = ZipDemographic.find(:all,
                                                  :select=>"id, lat, lng, #{distance_sql} as distance",
                                                  :order => 'distance asc',
                                                  :limit => 1,
                                                  :conditions => ["source ILIKE ?", "%#{params[:source]}%"])
        else
          raise 'Unsupported DB adapter'
      end

    elsif(params[:source]!=nil && params[:search]!=nil)
      case ActiveRecord::Base.connection.adapter_name
        when 'SQLite'  
          @zip_demographics = ZipDemographic.find(:all, :conditions => ["(zip LIKE ?) AND (source LIKE ?)", "%#{params[:search]}%", "%#{params[:source]}%"])
        when 'MySQL'
          @zip_demographics = ZipDemographic.find(:all, :conditions => ["(zip LIKE ?) AND (source LIKE ?)", "%#{params[:search]}%", "%#{params[:source]}%"])
        when 'PostgreSQL'
          @zip_demographics = ZipDemographic.find(:all, :conditions => ["(zip ILIKE ?) AND (source ILIKE ?)", "%#{params[:search]}%", "%#{params[:source]}%"])
        else
          raise 'Unsupported DB adapter'
      end
    end 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @zip_demographics }
      format.js { render :json => @zip_demographics.to_json() } 
    end
  end

  # GET /zip_demographics/1
  # GET /zip_demographics/1.xml
  def show
    @zip_demographic = ZipDemographic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @zip_demographic }
      format.js { render :json => @zip_demographic.to_json() } 
    end
  end

  # GET /zip_demographics/new
  # GET /zip_demographics/new.xml
  def new
    @zip_demographic = ZipDemographic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @zip_demographic }
    end
  end

  # GET /zip_demographics/1/edit
  def edit
    @zip_demographic = ZipDemographic.find(params[:id])
  end

  # POST /zip_demographics
  # POST /zip_demographics.xml
  def create
    @zip_demographic = ZipDemographic.new(params[:zip_demographic])

    respond_to do |format|
      if @zip_demographic.save
        flash[:notice] = 'Demographic was successfully created.'
        format.html { redirect_to(@zip_demographic) }
        format.xml  { render :xml => @zip_demographic, :status => :created, :location => @zip_demographic }
        format.js {
          render :json => {:success=>true,:id=>@zip_demographic.id.to_s}
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @zip_demographic.errors, :status => :unprocessable_entity }
        format.js do
          render :json => {:success=>false}
        end
      end
    end
  end

  # PUT /zip_demographics/1
  # PUT /zip_demographics/1.xml
  def update
    @zip_demographic = ZipDemographic.find(params[:id])

    respond_to do |format|
      if @zip_demographic.update_attributes(params[:zip_demographic])
        flash[:notice] = 'ZipDemographic was successfully updated.'
        format.html { redirect_to(@zip_demographic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @zip_demographic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /zip_demographics/1
  # DELETE /zip_demographics/1.xml
  def destroy
    @zip_demographic = ZipDemographic.find(params[:id])
    @zip_demographic.destroy

    respond_to do |format|
      format.html { redirect_to(zip_demographics_url) }
      format.xml  { head :ok }
    end
  end
end
