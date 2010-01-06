class CategoryLocationMembershipsController < ApplicationController
  # GET /category_location_memberships
  # GET /category_location_memberships.xml
  def index
    @category_location_memberships = CategoryLocationMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @category_location_memberships }
    end
  end

  # GET /category_location_memberships/1
  # GET /category_location_memberships/1.xml
  def show
    @category_location_membership = CategoryLocationMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category_location_membership }
    end
  end

  # GET /category_location_memberships/new
  # GET /category_location_memberships/new.xml
  def new
    @category_location_membership = CategoryLocationMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category_location_membership }
    end
  end

  # GET /category_location_memberships/1/edit
  def edit
    @category_location_membership = CategoryLocationMembership.find(params[:id])
  end

  # POST /category_location_memberships
  # POST /category_location_memberships.xml
  def create
    @category_location_membership = CategoryLocationMembership.new(params[:category_location_membership])

    respond_to do |format|
      if @category_location_membership.save
        flash[:notice] = 'CategoryLocationMembership was successfully created.'
        format.html { redirect_to(@category_location_membership) }
        format.xml  { render :xml => @category_location_membership, :status => :created, :location => @category_location_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category_location_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /category_location_memberships/1
  # PUT /category_location_memberships/1.xml
  def update
    @category_location_membership = CategoryLocationMembership.find(params[:id])

    respond_to do |format|
      if @category_location_membership.update_attributes(params[:category_location_membership])
        flash[:notice] = 'CategoryLocationMembership was successfully updated.'
        format.html { redirect_to(@category_location_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category_location_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /category_location_memberships/1
  # DELETE /category_location_memberships/1.xml
  def destroy
    @category_location_membership = CategoryLocationMembership.find(params[:id])
    @category_location_membership.destroy

    respond_to do |format|
      format.html { redirect_to(category_location_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
