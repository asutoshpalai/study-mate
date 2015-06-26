module Auth

  def self.registered(app)
    app.helpers AuthHelpers

    app.enable :sessions

    app.get '/login' do
      slim :login
    end

    app.post '/login' do
      pass = Digest::SHA256.hexdigest(params[:password])
      user  = Users.all(:username => params[:username], :pass => pass)
      if user.length == 1
        session[:logged] = true
        session[:uid] = user[0].id
        flash[:notice] = "Logged in sucessfully"
        redirect to('/tracks')
      else
        flash[:notice] = "Wrong username or password #{pass}"
      end

    end

    app.get '/signup' do
      slim :signup
    end

    app.post '/signup' do
      pass = Digest::SHA256.hexdigest(params[:pass])
      if Users.create(:name => params[:name], :username => params[:username], :pass => pass )
        session[:logged] = true
        flash[:notice] = "Signed up sucessfully"
        redirect to('/')
      else
        flash[:notice] = "Signup failed"
        slim :signup
      end
    end

    app.get '/logout' do
      session[:logged] = nil
      flash[:notice] = "You have logged out"
      redirect to('/')
    end

  end

end
