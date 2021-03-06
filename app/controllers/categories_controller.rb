class CategoriesController < ApplicationController

  before_filter :admin_login_required, :except => [:index, :show]

  # GET /categories
  # GET /categories.xml
  def index
    # this will return all if no search param is passed, 
    # so also acts like a normal index method
    
    case ActiveRecord::Base.connection.adapter_name
    when 'SQLite'
      @categories = Category.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
    when 'MySQL'
      @categories = Category.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
    when 'PostgreSQL'
      @categories = Category.find(:all, :conditions => ['name ILIKE ?', "%#{params[:search]}%"])
    else
      raise 'Unsupported DB adapter'
    end
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
      format.js { render :json => @categories.to_json() }
      format.text # index.text.erb
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(categories_url) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(categories_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
end
