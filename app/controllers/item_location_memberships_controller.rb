class ItemLocationMembershipsController < ApplicationController
  # GET /item_location_memberships
  # GET /item_location_memberships.xml
  def index
    @item_location_memberships = ItemLocationMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @item_location_memberships }
    end
  end

  # GET /item_location_memberships/1
  # GET /item_location_memberships/1.xml
  def show
    @item_location_membership = ItemLocationMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item_location_membership }
    end
  end

  # GET /item_location_memberships/new
  # GET /item_location_memberships/new.xml
  def new
    @item_location_membership = ItemLocationMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item_location_membership }
    end
  end

  # GET /item_location_memberships/1/edit
  def edit
    @item_location_membership = ItemLocationMembership.find(params[:id])
  end

  # POST /item_location_memberships
  # POST /item_location_memberships.xml
  def create
    @item_location_membership = ItemLocationMembership.new(params[:item_location_membership])

    respond_to do |format|
      if @item_location_membership.save
        flash[:notice] = 'ItemLocationMembership was successfully created.'
        format.html { redirect_to(@item_location_membership) }
        format.xml  { render :xml => @item_location_membership, :status => :created, :location => @item_location_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_location_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_location_memberships/1
  # PUT /item_location_memberships/1.xml
  def update
    @item_location_membership = ItemLocationMembership.find(params[:id])

    respond_to do |format|
      if @item_location_membership.update_attributes(params[:item_location_membership])
        flash[:notice] = 'ItemLocationMembership was successfully updated.'
        format.html { redirect_to(@item_location_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_location_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_location_memberships/1
  # DELETE /item_location_memberships/1.xml
  def destroy
    @item_location_membership = ItemLocationMembership.find(params[:id])
    @item_location_membership.destroy

    respond_to do |format|
      format.html { redirect_to(item_location_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
