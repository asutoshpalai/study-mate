require 'sinatra'
require "sinatra/reloader" if development?
require 'slim'
require './track'

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
