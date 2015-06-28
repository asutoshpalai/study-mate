module AuthHelpers

  def logged_in?
    session[:logged]
  end

  def authorized?
    logged_in?
  end

  def protected!
    halt 401,slim(:unauthorized) unless authorized?
  end

  def required_login!
    if not logged_in?
      flash[:notice] = "You need to sign in first"
      redirect to('/login')
    end
  end


  def log_in(id)
    user = Users.get(id)
    session[:logged] = true
    session[:uid] = user.id
  end

  def log_out
    session.clear
  end

  def get_user
    puts session.inspect
    Users.get(session[:uid])
  end

end

