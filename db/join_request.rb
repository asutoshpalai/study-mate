require 'dm-core'
require 'dm-migrations'

class JoinRequest
  include DataMapper::Resource

  property :id, Serial
  property :requested_track_id, Integer, :unique => :u
  property :user_request_id, Integer, :unique => :u

  belongs_to :requested_track, 'Track'
  belongs_to :user_request, 'Users'

end
