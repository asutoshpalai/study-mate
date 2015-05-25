require 'sinatra'
require 'slim'

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

