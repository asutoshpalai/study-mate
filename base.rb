require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sinatra/flash'
require 'v8'
require 'coffee-script'

class Base < Sinatra::Base
  register Auth
  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

  configure do
    DataMapper.finalize
    DataMapper.auto_upgrade!

  end

end
