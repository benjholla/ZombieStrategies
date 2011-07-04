require 'toto'
require 'config/environment.rb'

#point to your rails apps /public directory
use Rack::Static, :urls => ['/stylesheets', '/javascripts', '/images', '/favicon.ico'], :root => 'public'

use Rack::ShowExceptions
use Rack::CommonLogger

#run the toto application
toto = Toto::Server.new do

	#override the default location for the toto directories
	Toto::Paths = {
		:templates => "information/templates",
		:pages => "information/templates/pages",
		:articles => "information/articles"
	}

	#set your config variables here
	set :title,     'Zombie Strategies | ' + Dir.pwd.split('/').last
	set :author,    'Zombie Strategies'
	set :date,      lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
	set :disqus,    false                                     # disqus id, or false
	set :summary,   :max => 150, :delim => /~/   
	set :ext,       'txt'         
	set :root,      "index"
	set :cache,      28800  
	
	if RAILS_ENV != 'production'
		set :url, "http://127.0.0.1:3000/information/"
	else
		set :url, "http://zombiestrategies.com/information/"
	end
	
end

#create a rack app
app = Rack::Builder.new do
use Rack::CommonLogger

#map requests to /information to toto
map '/information' do
	run toto
end
#map all the other requests to rails
map '/' do
	if Rails.version.to_f >= 3.0
		ActionDispatch::Static
		run Rails.application
	else # Rails 2
		use Rails::Rack::Static
		run ActionController::Dispatcher.new
	end
end

end.to_app

run app