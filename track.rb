require './db/track'

get '/tracks' do
  @tracks = Track.all
  slim :tracks
end

get '/tracks/new' do
  halt(401,'Not Authorized') unless session[:admin]
  slim :new_track
end

post '/tracks/new' do
  halt(401,'Not Authorized') unless session[:admin]
  track = Track.create(params[:track])
  redirect to("/track/#{track.id}")
end

get '/track/:id' do 
  @track = Track.get(params[:id])
  puts @track.inspect
  slim :track_page
end

delete '/track/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  @track = Track.get(params[:id])
  @track.destroy
  redirect to("/tracks")
end

get '/track/:id/edit' do
  halt(401,'Not Authorized') unless session[:admin]
  @track = Track.get(params[:id])
  slim :edit_track
end

put'/track/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  track = Track.get(params[:id])
  track.update(params[:track])
  redirect to("/track/#{track.id}")
end
