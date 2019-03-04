enable :sessions

get '/' do
  cache_control :public, :max_age => 31536000
  if session[:user_id]
    erb :index
  else
    redirect "login"
  end
end

get '/price' do
  cache_control :public, :max_age => 31536000
  if session[:user_id]
    file='public/gas_price.txt'
    File.readlines(file).each do |line|
      @gas_price = line
    end
    erb :price
  else
    redirect "/"
  end
end

post '/price' do
  cache_control :public, :max_age => 31536000
  if session[:user_id]
    File.open("public/gas_price.txt", "w") { |file| file.puts params[:gas_price]}
    redirect '/price'
  else
    redirect '/login'
  end
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


