require 'dm-core'
require 'dm-migrations'

class Users

  include DataMapper::Resource
  property :id, Serial
  property :username, String, :unique => true, :required => true
  property :name, String, :required => true
  property :pass, String, :length=>64, :required => true
  property :signed_up_at, DateTime, :default => DateTime.now

  has n, :user_relations
  has n, :tracks, :through => :user_relations
  has n, :owntracks, 'Track', :child_key => :admin_id
  has n, :msgs, 'Msgs', :child_key => :user_id
  has n, :files, 'Files', :child_key => :user_id
  has n, :join_requests, :child_key => :user_request_id
  has n, :requested_tracks, 'Track', :through => :join_requests
end
