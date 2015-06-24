require 'digest'
require './db/track'
require './db/msgs'
require './db/files'

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

  def get_files(id = nil)
    if not id
      id = params[:id]
    end

    Files.all(:tid => id)
  end

  def get_file(tid = nil, filename = nil)

    if not tid
      tid = params[:id]
    end

    if not filename
      filename = params[:filename]
    end

    Files.all(:tid => tid, :name => filename)[0]
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
  @track.msgs = get_msgs
  @track.files = get_files
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
  @msg = Msgs.create(:tid => params[:id], :msg => params[:msg])
  if @msg
    slim :msg, :layout => false
  else
    return "failed"
  end
end

post '/track/:id/file' do
  file = params[:file]
  sha1 = Digest::SHA1.file(file[:tempfile]).hexdigest
  File.open('uploads/' + sha1, 'w') do |f|
    f.write(file[:tempfile].read)
  end
  @file = Files.create(:tid => params[:id], :name => file[:filename], :sha1 => sha1)
  if @file
    @track = find_track
    slim :file, :layout => false
  else
    return "failed"
  end
end

get '/track/:id/file/:filename' do
  @file = get_file
  send_file 'uploads/' + @file.sha1
end


put'/track/:id' do
  protected!
  track = find_track
  if track.update(params[:track])
    flash[:notice] = "Track updated successfully"
  end
  redirect to("/track/#{track.id}")
end
