require './db/track'

get '/tracks' do
  @tracks = Track.all
  slim :tracks
end

get '/tracks/new' do
  slim :new_track
end

post 'tracks/new' do
  @track = Track.create(params[:track])
  redirect to("/songs/#@track.id")
end

get '/tracks/:id' do 
  @track = Track.get(params[:id])
  puts @track.name
  slim :track_page
end


