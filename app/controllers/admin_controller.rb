class AdminController < ApplicationController
  
  before_filter :admin_login_required
  
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
  
  # GET /zs-admin
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
end
