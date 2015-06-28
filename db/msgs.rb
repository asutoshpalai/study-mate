require 'dm-core'
require 'dm-migrations'

class Msgs
  include DataMapper::Resource

  property :id, Serial
  property :track_id, Integer, :required => true
  property :user_id, Integer, :required => true
  property :msg, Text, :required => true
  property :posted_at, DateTime, :default => DateTime.now

  belongs_to :track
  belongs_to :user, 'Users'

end
