require 'dm-core'
require 'dm-migrations'

class Files
  include DataMapper::Resource
  property :id, Serial
  property :track_id, Integer, :required => true
  property :user_id, Integer, :required => true
  property :name, String, :unique => :track_id, :required => true
  property :sha1, String, :required => true
  property :created_at, DateTime, :default => DateTime.now

  belongs_to :track
  belongs_to :user, 'Users'
end
