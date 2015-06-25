require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sinatra/flash'
require 'v8'
require 'coffee-script'

class Base < Sinatra::Base
  register Auth
  register Sinatra::Flash

  helpers BaseHelpers

  configure :development do
    register Sinatra::Reloader
  end

  configure do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    DataMapper.finalize

  end

end
