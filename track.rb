require 'digest'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sass'
require 'sinatra/flash'
require './auth/auth'
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

class TrackController < Sinatra::Base
  enable :method_override
  register Sinatra::Flash
  register Sinatra::Auth

  helpers TrackHelpers

  configure do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    DataMapper.finalize

  end

  configure :development do
    register Sinatra::Reloader
  end

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path='/')
    (request.path == path || request.path == path + '/') ? "current" : nil
  end

  get '/' do
    find_tracks
    slim :tracks
  end

  get '/new' do
    protected!
    slim :new_track
  end

  post '/new' do
    protected!
    flash[:notice] = "Track created sucessfully" if create_track
    redirect to("/#{@track.id}")
  end

  get '/:id' do 
    @track = find_track
    @track.msgs = get_msgs
    @track.files = get_files
    slim :track_page
  end

  delete '/:id' do
    protected!
    if find_track.destroy
      flash[:notice] = "Track deleted"
    end
    redirect to("/")
  end

  get '/:id/edit' do
    protected!
    @track = find_track
    slim :edit_track
  end

  post '/:id/post' do
    @msg = Msgs.create(:tid => params[:id], :msg => params[:msg])
    if @msg
      slim :msg, :layout => false
    else
      return "failed"
    end
  end

  post '/:id/file' do
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

  get '/:id/file/:filename' do
    @file = get_file
    send_file 'uploads/' + @file.sha1
  end


  put'/:id' do
    protected!
    track = find_track
    if track.update(params[:track])
      flash[:notice] = "Track updated successfully"
    end
    redirect to("/#{track.id}")
  end
end
