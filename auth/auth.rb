require 'sinatra/base'
require 'sinatra/flash'

module Sinatra

  module Auth

    module Helpers

      def authorized?
        session[:admin]
      end


      def protected!
        halt 401,slim(:unauthorized) unless authorized?
      end

    end

    def self.registered(app)
      app.helpers Helpers

      app.enable :sessions

      app.set :username => 'admin', :password => 'sinatra'

      app.get '/login' do
        slim :login
      end

      app.post '/login' do
        if params[:username] == settings.username && params[:password] == settings.password
          session[:admin] = true
          flash[:notice] = "Logged in sucessfully"
          redirect to('/tracks')
        else
          flash[:notice] = "Wrong username or password"
        end

      end

      app.get '/logout' do
        session[:admin] = nil
        flash[:notice] = "You have logged out"
        redirect to('/')
      end

    end

  end

  register Auth
end
