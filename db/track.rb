require 'dm-core'
require 'dm-migrations'

class Track
  include DataMapper::Resource
  attr_accessor :msgs, :files
  property :id, Serial
  property :name, String, :unique => true, :required => true
  property :description, Text, :required => true
  property :admin_id, Integer, :required => true
  property :created_at, DateTime, :default => DateTime.now

  has n, :join_requests, :child_key => :requested_track_id
  has n, :user_requests, 'Users', :through => :join_requests
  belongs_to :admin, 'Users'
  has n, :user_relations
  has n, :users, 'Users', :through => :user_relations

end
