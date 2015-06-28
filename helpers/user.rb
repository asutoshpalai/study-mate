module UserHelpers
  def user
    if @user
      @user
    else
      @user = get_user
    end
  end

  def get_user
    puts session.inspect
    Users.get(session[:uid])
  end

end
