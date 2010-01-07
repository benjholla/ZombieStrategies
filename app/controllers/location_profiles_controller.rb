class LocationProfilesController < ApplicationController
  # GET /location_profiles
  # GET /location_profiles.xml
  def index
    # this will return all if no search param is passed, 
    # so also acts like a normal index method
    
    case ActiveRecord::Base.connection.adapter_name
    when 'SQLite'
      @location_profiles = LocationProfile.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"]).paginate :per_page => 10, 
      :page => params[:page], :conditions => ['name LIKE ?', "%#{params[:search]}%"], :order => 'name'
    when 'MySQL'
      @location_profiles = LocationProfile.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"]).paginate :per_page => 10, 
      :page => params[:page], :conditions => ['name LIKE ?', "%#{params[:search]}%"], :order => 'name'
    when 'PostgreSQL'
      @location_profiles = LocationProfile.find(:all, :conditions => ['name ILIKE ?', "%#{params[:search]}%"]).paginate :per_page => 10, 
      :page => params[:page], :conditions => ['name ILIKE ?', "%#{params[:search]}%"], :order => 'name'
    else
      raise 'Unsupported DB adapter'
    end   

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @location_profiles }
      format.text # index.text.erb
      format.js { render :json => @location_profiles.to_json() }
    end
  end

  # GET /location_profiles/1
  # GET /location_profiles/1.xml
  def show
    @location_profile = LocationProfile.find_by_name(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @location_profile }
      format.js { render :json => @location_profile.to_json(:include => {:categories => {}, :products => {}}) }
    end
  end

  # GET /location_profiles/new
  # GET /location_profiles/new.xml
  def new
    @location_profile = LocationProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location_profile }
    end
  end

  # GET /location_profiles/1/edit
  def edit
    @location_profile = LocationProfile.find_by_name(params[:id])
  end

  # POST /location_profiles
  # POST /location_profiles.xml
  def create
    params[:location_profile][:category_ids] ||= []
    params[:location_profile][:product_ids] ||= []
    @location_profile = LocationProfile.new(params[:location_profile])

    respond_to do |format|
      if @location_profile.save
        flash[:notice] = @location_profile.name + ' profile created.'
        format.html { redirect_to(@location_profile) }
        format.xml  { render :xml => @location_profile, :status => :created, :location => @location_profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /location_profiles/1
  # PUT /location_profiles/1.xml
  def update
    @location_profile = LocationProfile.find_by_name(params[:id])
    
    respond_to do |format|
      if @location_profile.update_attributes(params[:location_profile])
        flash[:notice] = @location_profile.name + ' profile updated.'
        format.html { redirect_to(@location_profile) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /location_profiles/1
  # DELETE /location_profiles/1.xml
  def destroy
    @location_profile = LocationProfile.find_by_name(params[:id])
    @location_profile.destroy

    respond_to do |format|
      format.html { redirect_to(location_profiles_url) }
      format.xml  { head :ok }
    end
  end
end
