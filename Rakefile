require './config/environment'
require 'sinatra/activerecord/rake'

desc 'List defined routes'
task :routes do
  require 'app/web/web'

  Shoebox::Server.routes.map do |method, routes|
    routes.map { |r| r.first.to_s }.map do |route|
      "#{method.rjust(7, ' ')} #{route}"
    end
  end.flatten.sort.each do |route|
    puts route
  end
end