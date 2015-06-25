require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sinatra/flash'
require 'v8'
require 'coffee-script'
require './auth/auth'

class StudyMate < Sinatra::Base
  register Sinatra::Auth
  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader
  end

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path='/')
    (request.path == path || request.path == path + '/') ? "current" : nil
  end

  get('/styles.css') { scss :styles }
  get('/javascripts/application.js') { coffee :application }

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
end
