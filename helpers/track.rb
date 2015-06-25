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
