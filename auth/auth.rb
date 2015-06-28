require 'digest'

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
        log_in(user[0].id)
        flash[:notice] = "Logged in sucessfully"
        redirect to('/tracks')
      else
        flash[:notice] = "Wrong username or password #{pass}"
        redirect to('/login')
      end

    end

    app.get '/signup' do
      slim :signup
    end

    app.post '/signup' do
      pass = Digest::SHA256.hexdigest(params[:pass])
      user = Users.create(:name => params[:name], :username => params[:username], :pass => pass )
      if user
        log_in(user.id)
        flash[:notice] = "Signed up sucessfully"
        redirect to('/')
      else
        flash[:notice] = "Signup failed"
        slim :signup
      end
    end

    app.get '/logout' do
      log_out
      flash[:notice] = "You have logged out"
      redirect to('/')
    end

  end

end
