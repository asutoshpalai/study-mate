require 'sinatra/base'

require './root'
require './track'

map('/tracks') { run TrackController}
map('/') {run RootController}
