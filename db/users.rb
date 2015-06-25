require 'dm-core'
require 'dm-migrations'

class Users

  include DataMapper::Resource
  property :id, Serial
  property :username, String, :unique => true
  property :name, String
  property :pass, String
  property :signed_up_at, DateTime, :default => DateTime.now

end
