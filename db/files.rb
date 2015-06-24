require 'dm-core'
require 'dm-migrations'

class Files
  include DataMapper::Resource
  property :id, Serial
  property :tid, Integer
  property :name, String, :unique => :tid
  property :sha1, String
  property :created_at, DateTime, :default => DateTime.now
end
