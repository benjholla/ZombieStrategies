class LocationProfilesController < ApplicationController
  # GET /location_profiles
  # GET /location_profiles.xml
  def index
    @location_profiles = LocationProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @location_profiles }
    end
  end

  # GET /location_profiles/1
  # GET /location_profiles/1.xml
  def show
    @location_profile = LocationProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location_profile }
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
    @location_profile = LocationProfile.find(params[:id])
  end

  # POST /location_profiles
  # POST /location_profiles.xml
  def create
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
    @location_profile = LocationProfile.find(params[:id])

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
    @location_profile = LocationProfile.find(params[:id])
    @location_profile.destroy

    respond_to do |format|
      format.html { redirect_to(location_profiles_url) }
      format.xml  { head :ok }
    end
  end
end
