class ItemLocationProfileMembershipsController < ApplicationController
  # GET /item_location_profile_memberships
  # GET /item_location_profile_memberships.xml
  def index
    @item_location_profile_memberships = ItemLocationProfileMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @item_location_profile_memberships }
    end
  end

  # GET /item_location_profile_memberships/1
  # GET /item_location_profile_memberships/1.xml
  def show
    @item_location_profile_membership = ItemLocationProfileMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item_location_profile_membership }
    end
  end

  # GET /item_location_profile_memberships/new
  # GET /item_location_profile_memberships/new.xml
  def new
    @item_location_profile_membership = ItemLocationProfileMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item_location_profile_membership }
    end
  end

  # GET /item_location_profile_memberships/1/edit
  def edit
    @item_location_profile_membership = ItemLocationProfileMembership.find(params[:id])
  end

  # POST /item_location_profile_memberships
  # POST /item_location_profile_memberships.xml
  def create
    @item_location_profile_membership = ItemLocationProfileMembership.new(params[:item_location_profile_membership])

    respond_to do |format|
      if @item_location_profile_membership.save
        flash[:notice] = 'ItemLocationProfileMembership was successfully created.'
        format.html { redirect_to(@item_location_profile_membership) }
        format.xml  { render :xml => @item_location_profile_membership, :status => :created, :location => @item_location_profile_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_location_profile_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_location_profile_memberships/1
  # PUT /item_location_profile_memberships/1.xml
  def update
    @item_location_profile_membership = ItemLocationProfileMembership.find(params[:id])

    respond_to do |format|
      if @item_location_profile_membership.update_attributes(params[:item_location_profile_membership])
        flash[:notice] = 'ItemLocationProfileMembership was successfully updated.'
        format.html { redirect_to(@item_location_profile_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_location_profile_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_location_profile_memberships/1
  # DELETE /item_location_profile_memberships/1.xml
  def destroy
    @item_location_profile_membership = ItemLocationProfileMembership.find(params[:id])
    @item_location_profile_membership.destroy

    respond_to do |format|
      format.html { redirect_to(item_location_profile_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
