require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Track
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :unique => true
  property :description, Text
  property :created_at, DateTime, :default => DateTime.now

end

DataMapper.finalize
