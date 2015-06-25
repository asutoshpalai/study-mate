require_relative './strapup'

map('/tracks') { run TrackController}
map('/') {run RootController}
