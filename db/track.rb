require 'dm-core'
require 'dm-migrations'

class Track
  include DataMapper::Resource
  attr_accessor :msgs, :files
  property :id, Serial
  property :name, String, :unique => true
  property :description, Text
  property :admin, Integer
  property :created_at, DateTime, :default => DateTime.now

  has n, :user_relations
  has n, :users, 'Users', :through => :user_relations

end
