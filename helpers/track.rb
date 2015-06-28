module TrackHelpers

  def find_tracks
    if user
      @tracks = user.tracks.all
    else
      @tracks = Track.all
    end
  end

  def find_track
    user.tracks.get(params[:id])
  end

  def create_track
    @track = Track.create(params[:track], :admin => user.id)
    UserRelation.create(:track_id => @track.id, :users_id => user.id)
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
