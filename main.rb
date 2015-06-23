require 'sinatra'
require "sinatra/reloader" if development?
require 'slim'
require 'sinatra/flash'
require './track'


configure do
  enable :sessions
  set :username, 'admin'
  set :password, 'sinatra'
end

helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path='/')
    (request.path == path || request.path == path + '/') ? "current" : nil
  end
end

get('/styles.css') { scss :styles }

get '/' do
  title = "StudyMate::Home"
  slim :home, :locals => {:title => title}
end

get '/about' do
  slim :about, :locals => {:title => "StudyMata :: About"}
end

not_found do
  slim :not_found
end

get '/login' do
  slim :login
end

post '/login' do
  if params[:username] = settings.username && params[:password] === settings.password
    session[:admin] = true
    redirect to('/tracks')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect to('/')
end
