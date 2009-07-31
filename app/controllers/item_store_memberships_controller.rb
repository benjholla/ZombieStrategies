class ItemStoreMembershipsController < ApplicationController
  # GET /item_store_memberships
  # GET /item_store_memberships.xml
  def index
    @item_store_memberships = ItemStoreMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @item_store_memberships }
    end
  end

  # GET /item_store_memberships/1
  # GET /item_store_memberships/1.xml
  def show
    @item_store_membership = ItemStoreMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item_store_membership }
    end
  end

  # GET /item_store_memberships/new
  # GET /item_store_memberships/new.xml
  def new
    @item_store_membership = ItemStoreMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item_store_membership }
    end
  end

  # GET /item_store_memberships/1/edit
  def edit
    @item_store_membership = ItemStoreMembership.find(params[:id])
  end

  # POST /item_store_memberships
  # POST /item_store_memberships.xml
  def create
    @item_store_membership = ItemStoreMembership.new(params[:item_store_membership])

    respond_to do |format|
      if @item_store_membership.save
        flash[:notice] = 'ItemStoreMembership was successfully created.'
        format.html { redirect_to(@item_store_membership) }
        format.xml  { render :xml => @item_store_membership, :status => :created, :location => @item_store_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_store_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_store_memberships/1
  # PUT /item_store_memberships/1.xml
  def update
    @item_store_membership = ItemStoreMembership.find(params[:id])

    respond_to do |format|
      if @item_store_membership.update_attributes(params[:item_store_membership])
        flash[:notice] = 'ItemStoreMembership was successfully updated.'
        format.html { redirect_to(@item_store_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_store_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_store_memberships/1
  # DELETE /item_store_memberships/1.xml
  def destroy
    @item_store_membership = ItemStoreMembership.find(params[:id])
    @item_store_membership.destroy

    respond_to do |format|
      format.html { redirect_to(item_store_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
