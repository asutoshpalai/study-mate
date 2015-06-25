Dir.glob('./db/*.rb').each {|file| require file}
Dir.glob('./helpers/*.rb').each {|file| require file}
require './auth/auth'
require './base'
Dir.glob('./controllers/*.rb').each {|file| require file}
