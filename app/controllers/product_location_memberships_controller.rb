class ProductLocationMembershipsController < ApplicationController
  # GET /product_location_memberships
  # GET /product_location_memberships.xml
  def index
    @product_location_memberships = ProductLocationMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_location_memberships }
    end
  end

  # GET /product_location_memberships/1
  # GET /product_location_memberships/1.xml
  def show
    @product_location_membership = ProductLocationMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_location_membership }
    end
  end

  # GET /product_location_memberships/new
  # GET /product_location_memberships/new.xml
  def new
    @product_location_membership = ProductLocationMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_location_membership }
    end
  end

  # GET /product_location_memberships/1/edit
  def edit
    @product_location_membership = ProductLocationMembership.find(params[:id])
  end

  # POST /product_location_memberships
  # POST /product_location_memberships.xml
  def create
    @product_location_membership = ProductLocationMembership.new(params[:product_location_membership])

    respond_to do |format|
      if @product_location_membership.save
        flash[:notice] = 'ProductLocationMembership was successfully created.'
        format.html { redirect_to(@product_location_membership) }
        format.xml  { render :xml => @product_location_membership, :status => :created, :location => @product_location_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_location_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_location_memberships/1
  # PUT /product_location_memberships/1.xml
  def update
    @product_location_membership = ProductLocationMembership.find(params[:id])

    respond_to do |format|
      if @product_location_membership.update_attributes(params[:product_location_membership])
        flash[:notice] = 'ProductLocationMembership was successfully updated.'
        format.html { redirect_to(@product_location_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_location_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_location_memberships/1
  # DELETE /product_location_memberships/1.xml
  def destroy
    @product_location_membership = ProductLocationMembership.find(params[:id])
    @product_location_membership.destroy

    respond_to do |format|
      format.html { redirect_to(product_location_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
