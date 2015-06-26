module BaseHelpers

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end 

  def current?(path='/')
    (request.path == path || request.path == path + '/') ? "current" : nil 
  end 

  def get_user
    @user = Users.get(session[:uid])
  end

end
