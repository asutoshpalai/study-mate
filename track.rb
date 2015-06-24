require './db/track'
require './db/msgs'

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

  def get_msgs(id = nil)
    if not id
      id = params[:id]
    end

    Msgs.all(:tid => id)
  end

end

helpers TrackHelpers

get '/tracks' do
  find_tracks
  slim :tracks
end

get '/tracks/new' do
  protected!
  slim :new_track
end

post '/tracks/new' do
  protected!
  flash[:notice] = "Track created sucessfully" if create_track
  redirect to("/track/#{@track.id}")
end

get '/track/:id' do 
  @track = find_track
  puts find_track
  puts @track
  @track.msgs = get_msgs
  slim :track_page
end

delete '/track/:id' do
  protected!
  if find_track.destroy
    flash[:notice] = "Track deleted"
  end
  redirect to("/tracks")
end

get '/track/:id/edit' do
  protected!
  @track = find_track
  slim :edit_track
end

post '/track/:id/post' do
  if Msgs.create(:tid => params[:id], :msg => params[:msg])
    return "true"
  else
    return "failed"
  end
end

put'/track/:id' do
  protected!
  track = find_track
  if track.update(params[:track])
    flash[:notice] = "Track updated successfully"
  end
  redirect to("/track/#{track.id}")
end
