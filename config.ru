require 'sinatra/base'

require './main'
require './track'

map('/tracks') { run TrackController}
map('/') {run StudyMate}
