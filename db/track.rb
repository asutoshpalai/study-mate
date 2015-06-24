require 'dm-core'
require 'dm-migrations'

class Track
  include DataMapper::Resource
  attr_accessor :msgs
  property :id, Serial
  property :name, String, :unique => true
  property :description, Text
  property :created_at, DateTime, :default => DateTime.now

end
