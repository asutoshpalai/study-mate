class RootController < Base

  get('/styles.css') { scss :styles }
  get('/javascripts/application.js') { coffee :application }

  get '/' do
    title = "StudyMate::Home"
    slim :home, :locals => {:title => title}
  end

  get '/about' do
    slim :about, :locals => {:title => "StudyMata :: About"}
  end

  not_found do
    slim :not_found
  end
end
