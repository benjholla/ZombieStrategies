class LocationClassificationsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]

  # GET /location_classifications
  # GET /location_classifications.xml
  def index
    @location_classifications = LocationClassification.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @location_classifications }
    end
  end

  # GET /location_classifications/1
  # GET /location_classifications/1.xml
  def show
    @location_classification = LocationClassification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location_classification }
    end
  end

  # GET /location_classifications/new
  # GET /location_classifications/new.xml
  def new
    @location_classification = LocationClassification.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location_classification }
    end
  end

  # GET /location_classifications/1/edit
  def edit
    @location_classification = LocationClassification.find(params[:id])
  end

  # POST /location_classifications
  # POST /location_classifications.xml
  def create
    @location_classification = LocationClassification.new(params[:location_classification])

    respond_to do |format|
      if @location_classification.save
        flash[:notice] = 'LocationClassification was successfully created.'
        format.html { redirect_to(@location_classification) }
        format.xml  { render :xml => @location_classification, :status => :created, :location => @location_classification }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location_classification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /location_classifications/1
  # PUT /location_classifications/1.xml
  def update
    @location_classification = LocationClassification.find(params[:id])

    respond_to do |format|
      if @location_classification.update_attributes(params[:location_classification])
        flash[:notice] = 'LocationClassification was successfully updated.'
        format.html { redirect_to(@location_classification) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location_classification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /location_classifications/1
  # DELETE /location_classifications/1.xml
  def destroy
    @location_classification = LocationClassification.find(params[:id])
    @location_classification.destroy

    respond_to do |format|
      format.html { redirect_to(location_classifications_url) }
      format.xml  { head :ok }
    end
  end
end
