class ApplicationController < Sinatra::Base
  enable :sessions

  register do
    def auth (type)
      condition do
        redirect "/login" unless send("is_#{type}?")
      end
    end
  end

  helpers do
    def is_user?
      @user != nil
    end
  end

  before do
    if session[:user_id] != nil
      @user = User.find(session[:user_id])
    else
      @user = nil
    end
  end

  get '/' do
    cache_control :public, :max_age => 31536000
    unless session[:user_id] != nil
      redirect "login"
    else
      erb :index
    end
  end

  get '/price', :auth => :user do
    cache_control :public, :max_age => 31536000
    file='public/gas_price.txt'
    File.readlines(file).each do |line|
      @gas_price = line
    end
    erb :price
  end

  post '/price', :auth => :user do
    cache_control :public, :max_age => 31536000
    File.open("public/gas_price.txt", "w") { |file| file.puts params[:gas_price]}
    redirect '/price'
  end

  get '/login' do
    cache_control :public, :max_age => 31536000
    erb :login
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/"
    else
      redirect "/login"
    end
  end

  get '/logout' do
    cache_control :public, :max_age => 31536000
    session[:user_id] = nil
    session.clear
    redirect "/"
  end
end
