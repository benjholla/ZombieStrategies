ActionController::Routing::Routes.draw do |map|
  # See how all your routes lay out with "rake routes"
  
  # resources
  map.resources :users
  map.resource :session
  map.resources :item_store_memberships
  map.resources :items
  map.resources :stores, :collection => {:create => :get}
  map.resources :homes
  map.resources :twitter_trends, :has_many => :twitter_computations
  map.resources :twitter_computations

  # home page and root path of the app
  map.root :controller => "information", :action => "home" 
  
  # new user registration
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  # admin control panel
  map.admin '/zs-admin', :controller => 'admin', :action => 'index'
  
  # plan page
  map.plan '/plan', :controller => 'stores', :action => 'index'
  
  # monitor page
  map.monitor '/monitor', :controller => 'twitter_trends', :action => 'index'
  
  # profile page
  map.profile '/profile', :controller => 'users', :action => 'profile'

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':action.:format', :controller => 'information'
  
end
