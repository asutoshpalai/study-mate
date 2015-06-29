require 'dm-core'
require 'dm-migrations'

################################################
# Track the relationship of the users with track
# 1 - Admin
# 2 - User
#################################################

class UserRelation

  include DataMapper::Resource
  property :id, Serial

  property :track_id, Integer, :unique => :track_id, :required => true
  property :users_id, Integer, :unique => :track_id
  property :relation, Integer, :required => true
  property :last_modified, DateTime, :default => DateTime.now

  belongs_to :track
  belongs_to :users

end
