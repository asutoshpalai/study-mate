require './db/track'

module TrackHelpers

  def find_tracks
    @tracks = Track.all
  end

  def find_track
    Track.get(params[:id])
  end

  def create_track
    @track = Track.create(params[:track])
  end
  
end

helpers TrackHelpers

get '/tracks' do
  find_tracks
  slim :tracks
end

get '/tracks/new' do
  halt(401,'Not Authorized') unless session[:admin]
  slim :new_track
end

post '/tracks/new' do
  halt(401,'Not Authorized') unless session[:admin]
  flash[:notice] = "Track created sucessfully" if create_track
  redirect to("/track/#{@track.id}")
end

get '/track/:id' do 
  @track = find_track
  slim :track_page
end

delete '/track/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  if find_track.destroy
    flash[:notice] = "Track deleted"
  end
  redirect to("/tracks")
end

get '/track/:id/edit' do
  halt(401,'Not Authorized') unless session[:admin]
  @track = find_track
  slim :edit_track
end

put'/track/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  track = find_track
  if track.update(params[:track])
    flash[:notice] = "Track updated successfully"
  end
  redirect to("/track/#{track.id}")
end
