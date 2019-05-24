require 'sinatra'
#require 'sinatra/reloader' if development?
require 'sass'
require 'erb'
require './student'
require './comment'
#require 'dm-timestamps'

#home, about, contact, students, comment, video, login

get('/style.css'){scss :style}

configure :development do
DataMapper.setup(:default,
"sqlite3://#{Dir.pwd}/students.db")
end

configure :production do
DataMapper.setup(:default,
ENV['DATABASE_URL'])
end

get '/' do
  @title = "Home"
  erb :home
end

get '/home' do
  @title = "Home"
  erb :home
end

get '/about' do
  @title = "Additional Information"
  erb :about
end

get '/contact' do
  @title = "Contact Information"
  erb :contact
end


get '/video' do
  @title = "Video"
  erb :video
end

get '/login' do
  @title = "Login"
  erb :login
end

post '/login' do
  if params[:username] == settings.username
     params[:password] == settings.password
     session[:admin] = true
     redirect to ('/home')
  else
    erb :login
  end
end

get '/logout' do
 session.clear
 redirect to ('/login')
end

not_found do
  @title = "Page not found"
  "page not found"
end
