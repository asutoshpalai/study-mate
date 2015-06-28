require 'dm-core'
require 'dm-migrations'

class Msgs
  include DataMapper::Resource

  property :id, Serial
  property :tid, Integer, :required => true
  property :msg, Text, :required => true
  property :posted_at, DateTime, :default => DateTime.now

end
