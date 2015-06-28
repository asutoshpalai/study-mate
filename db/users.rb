require 'dm-core'
require 'dm-migrations'

class Users

  include DataMapper::Resource
  property :id, Serial
  property :username, String, :unique => true, :required => true
  property :name, String, :required => true
  property :pass, String, :required => true
  property :signed_up_at, DateTime, :default => DateTime.now

  has n, :user_relations
  has n, :tracks, :through => :user_relations

end
