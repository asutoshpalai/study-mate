require 'dm-core'
require 'dm-migrations'

class Files
  include DataMapper::Resource
  property :id, Serial
  property :tid, Integer, :required => true
  property :name, String, :unique => :tid, :required => true
  property :sha1, String, :required => true
  property :created_at, DateTime, :default => DateTime.now
end
