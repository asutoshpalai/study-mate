require_relative './strapup'

map('/user') { run UserController }
map('/tracks') { run TrackController}
map('/') {run RootController}
