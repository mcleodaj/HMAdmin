# Require config/environment.rb
require ::File.expand_path('../config/environment',  __FILE__)

set :app_file, __FILE__

configure do
  # See: http://www.sinatrarb.com/faq.html#sessions
  use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => ENV['secret']

  # Set the views to 
  set :views, File.join(Sinatra::Application.root, "app", "views")
end

run Sinatra::Application
