require './db/track'

get '/tracks' do
  @tracks = Track.all
  slim :tracks
end

get '/tracks/new' do
  slim :new_track
end

post '/tracks/new' do
  track = Track.create(params[:track])
  redirect to("/track/#{track.id}")
end

get '/track/:id' do 
  @track = Track.get(params[:id])
  puts @track.inspect
  slim :track_page
end

delete '/track/:id' do
  @track = Track.get(params[:id])
  @track.destroy
  redirect to("/tracks")
end
