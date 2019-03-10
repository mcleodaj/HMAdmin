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
  session.delete 'init'
  unless session[:user_id] != nil
    redirect "login"
  else
    erb :index
  end
end

get '/price', :auth => :user do
  cache_control :public, :max_age => 31536000
  session.delete 'init'
  file='public/gas_price.txt'
  File.readlines(file).each do |line|
    @gas_price = line
  end
  erb :price
end

post '/price' do
  cache_control :public, :max_age => 31536000
  session.delete 'init'
  @user = User.find(params[:user_id])
  if @user != nil
    File.open("public/gas_price.txt", "w") { |file| file.puts params[:gas_price]}
    redirect '/price'
  else
    redirect 'login'
  end
end

get '/login' do
  cache_control :public, :max_age => 31536000
  session.delete 'init'
  erb :login
end

post '/login' do
  user = User.find_by(:username => params[:username])
  session.delete 'init'
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/"
  else
    redirect "/login"
  end
end

post '/logout' do
  cache_control :public, :max_age => 31536000
  session.delete 'init'
  session[:user_id] = nil
  session.clear
  redirect "/"
end  
