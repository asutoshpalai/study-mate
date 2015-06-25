require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sinatra/flash'
require 'v8'
require 'coffee-script'
require './auth/auth'

class Base < Sinatra::Base
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
end
