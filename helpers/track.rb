module TrackHelpers

  def find_tracks
    if user
      @tracks = user.tracks.all
    else
      @tracks = Track.all
    end
  end

  def all_tracks
    Track.all
  end

  def find_track
    return @track if defined? @track
    @track = user.tracks.get(params[:id])
  end

  def track_users
    find_track.users.all
  end

  def create_track
    t = params[:track]
    t[:admin_id] = user.id
    t[:name] = clean_input t[:name]
    t[:description] = clean_input t[:description]
    @track = Track.create(t)
    puts @track.inspect
    UserRelation.create(:track_id => @track.id, :users_id => user.id, :relation => 1)
  end

  def add_user_to_track(tid, uid, role = 2)
    if Track.get(tid).admin.id != user.id
      unauthorized!
    end

    UserRelation.create(:track_id => @track.id, :users_id => uid, :relation => role)
  end

  def get_msgs(id = nil)
    if not id
      id = params[:id]
    end

    Msgs.all(:track_id => id)
  end

  def get_files(id = nil)
    if not id
      id = params[:id]
    end

    Files.all(:track_id => id)
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

  def admin?
    find_track.admin.id === user.id
  end

end
