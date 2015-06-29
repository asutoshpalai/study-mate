module AuthHelpers

  def logged_in?
    session[:logged]
  end

  def authorized?
    logged_in? and find_track
  end

  def protected!
    unauthorized! unless authorized?
  end
  
  def unauthorized!
    halt 401,slim(:unauthorized) 
  end

  def required_login!
    if not logged_in?
      flash[:notice] = "You need to sign in first"
      redirect '/login'
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

end

