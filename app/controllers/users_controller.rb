class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  before_filter :login_required, :except => [:new, :create]
  before_filter :admin_login_required, :only => [:index, :destroy]

  def admin_or_owner?
    admin? || current_user.id == User.find(params[:id]).id
  end

  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to new_session_path
        flash[:error] = 'Only an Admin can access this page.'
      end
      # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
      # Add any other API formats here.  (Some browsers, notably IE6, send Accept: */* and trigger 
      # the 'format.any' block incorrectly. See http://bit.ly/ie6_borken or http://bit.ly/ie6_borken2
      # for a workaround.)
      format.any(:json, :xml) do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  # GET /users
  def index
    @users = User.paginate :per_page => 10, :page => params[:page],
                           :conditions => ['login like ?', "%#{params[:search]}%"],
                           :order => 'login'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if admin_or_owner?
      @user = User.find(params[:id])
      respond_to do |format|
        format.xml  { render :xml => @user }
      end
    else
      flash[:error] = 'Restricted Access'
      redirect_to user_path(current_user)
    end
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    # reset the is_admin property for new users to false just incase someone crafts a form
    @user.is_admin = 0
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "This information is not valid, please try again."
      render :action => 'new'
    end
  end
  
  # GET /users/1/edit
  def edit
    if admin_or_owner?
      @user = User.find(params[:id])
    else
      flash[:error] = 'Restricted Access'
      redirect_to edit_user_path(current_user)
    end
  end
  
  def profile
    @user = current_user
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    if admin_or_owner?
      @user = User.find(params[:id])
      # check and reset the is_admin property just incase someone crafts a form
      if !authorized?
        if @user.is_admin == 0
          @user.is_admin = 0
        else
          @user.is_admin = 1
        end
      end
      respond_to do |format|
        if @user.update_attributes(params[:user])
          flash[:notice] = 'Your preferences have been updated.'
          format.html { redirect_to root_path }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = 'Restricted Access'
      redirect_to edit_user_path(current_user)
    end
  end
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.login != "admin"
        @user.destroy
        flash[:notice] = 'User was successfully removed.'
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      else
        flash[:error] = 'Default admin user cannot be removed!'
        format.html { redirect_to(users_url) }
      end
    end
  end
  
end
