require 'dm-core'
require 'dm-migrations'

class Msgs
  include DataMapper::Resource

  property :id, Serial
  property :tid, Integer
  property :msg, Text
  property :posted_at, DateTime, :default => DateTime.now

end
