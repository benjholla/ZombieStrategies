class StoresController < ApplicationController
  # GET /stores
  # GET /stores.xml
  def index
    @stores = Store.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stores }
      format.js {render :json => @stores.to_json(:include => {:items => {}}) } 
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