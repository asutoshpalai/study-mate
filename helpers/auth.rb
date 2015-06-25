module AuthHelpers

  def authorized?
    session[:logged]
  end


  def protected!
    halt 401,slim(:unauthorized) unless authorized?
  end

end

