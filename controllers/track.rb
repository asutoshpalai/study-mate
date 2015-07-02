require 'digest'

class TrackController < Base
  enable :method_override

  @@connections = Hash.new { |h, i| h[i] = [] }

  get '/' do
    required_login!
    find_tracks
    @othertracks = all_tracks.select { |t| not @tracks.include? t }
    slim :tracks
  end

  get '/new' do
    required_login!
    slim :new_track
  end

  post '/new' do
    required_login!
    flash[:notice] = "Track created sucessfully" if create_track
    redirect to("/#{@track.id}")
  end

  get '/:id' do 
    protected!
    @track = find_track
    @track.msgs = get_msgs
    @track.files = get_files
    @users = @track.users.all
    @requests = @track.user_requests.all
    slim :track_page
  end

  delete '/:id' do
    protected!
    unauthorized! unless admin?
    if find_track.destroy
      flash[:notice] = "Track deleted"
    end
    redirect to("/")
  end

  get '/:id/edit' do
    protected!
    @track = find_track
    unauthorized! unless admin?
    slim :edit_track
  end

  get '/:id/users' do
    protected!
    @track = find_track
    @users = track_users
    slim :track_users
  end

  get '/:id/stream', provides: 'text/event-stream' do
    protected!
    id = params[:id]
    stream :keep_open do |out|
          @@connections[id] << out
          out.callback { @@connections[id].delete(out)   }
    end
  end

  post '/:id/users' do
    protected!
    unauthorized! unless admin?
    find_track
    tid = @track.id
    uid = Users.all(:username => params[:username])[0].id
    add_user_to_track tid, uid
    @users = @track.users.all
    slim :users_list, :layout => false
  end

  post '/:id/post' do
    protected!
    @msg = Msgs.create(:track_id => params[:id], :msg => clean_input(params[:msg]), :user_id => user.id)
    if @msg
      ret = slim :msg, :layout => false
      id = params[:id]

      Thread.new do
        @@connections[id].each { |out| out << "data: #{ret}\n\n" }
      end

      ret
   else
      return "failed"
    end
  end

  post '/:id/file' do
    protected!
    file = params[:file]
    sha1 = Digest::SHA1.file(file[:tempfile]).hexdigest
    File.open('uploads/' + sha1, 'w') do |f|
      f.write(file[:tempfile].read)
    end
    @file = Files.create(:track_id => params[:id], :user_id => user.id, :name => clean_input(file[:filename]), :sha1 => sha1)
    if @file
      find_track
      msg = slim :file_desc, :layout => false
      @msg = Msgs.create(:track_id => params[:id], :msg => msg, :user_id => user.id)
      id = params[:id]

      ret = slim :file, :layout => false
      Thread.new do
        @@connections[id].each { |out| out << "data: #{ret}\n\n" }
      end

      ret
    else
      return "failed"
    end
  end

  get '/:id/file/:filename' do
    protected!
    @file = get_file
    send_file 'uploads/' + @file.sha1
  end

  put'/:id' do
    protected!
    track = find_track
    unauthorized! unless admin?
    t = params[:track]
    t[:name] = clean_input t[:name]
    t[:description] = clean_input t[:description]
    if track.update(t)
      flash[:notice] = "Track updated successfully"
    end
    redirect to("/#{track.id}")
  end

  get '/:id/join' do
    required_login!
    res = JoinRequest.create(:requested_track_id => find_track(false).id, :user_request_id => user.id)
    if res
      flash[:notice] = "Request sent"
    end
    redirect to("/")
  end

  post '/:id/join' do
    protected!
    unauthorized! unless admin?
    tid = find_track.id
    uid = Users.all(:username => params[:username])[0].id
    add_user_to_track tid, uid
    JoinRequest.all(:requested_track_id => tid, :user_request_id => uid)[0].destroy
    @users = @track.users.all
    slim :users_list, :layout => false
  end

  delete '/:id/join' do
    protected!
    unauthorized! unless admin?
    tid = find_track.id
    uid = Users.all(:username => params[:username])[0].id
    if JoinRequest.all(:requested_track_id => tid, :user_request_id => uid)[0].destroy
      "success"
    else
      "failed"
    end
  end

end
