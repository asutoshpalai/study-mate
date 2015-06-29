require 'rack/utils'

module BaseHelpers

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end 

  def current?(path='/')
    (request.path == path || request.path == path + '/') ? "current" : nil 
  end 

  def clean_input(text)
    Rack::Utils.escape_html text
  end

end
