require 'digest'

class UserController < Base

  enable :method_override
  
  get '/' do
    required_login!
    @user = get_user
    slim :user_page
  end

  get '/settings' do
    required_login!
    @user = get_user

    slim :settings
  end

  put '/settings' do
    required_login!
    @user = get_user
    if params[:value] === 'name'
      @user.update(:name => params[:name])
      flash.now[:notice] = "Your name changed successfully"
    elsif params[:value] === 'password'
      oldpass = Digest::SHA256.hexdigest(params[:oldpass])
      if @user.pass === oldpass
        @user.update(:pass => Digest::SHA256.hexdigest(params[:newpass]))
        flash.now[:notice] = "Your password changed successfully"
      end
    end

    slim :settings
  end

  delete '/settings' do
    required_login!
    @user = get_user
    log_out
    @user.destroy
    redirect to('/')
  end

end
