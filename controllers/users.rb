class UserController < Base

  enable :method_override
  helpers UserHelpers
  
  get '/' do
    @user = get_user
    if not @user
      flash[:notice] = "You need to sign in first"
      redirect to('/login')
    end
    slim :user_page
  end
end
