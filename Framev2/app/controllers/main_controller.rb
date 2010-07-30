class MainController < ApplicationController
	
  def index
  	@friend = Friend.find(session[:friend_id]);
  	if (@friend)
  		redirect_to(:controller => 'users',:action => 'menu', :id => @friend.user_id );
  	else
  		 redirect_to(:action => "login")
  	end
  end
  
  def login
    session[:friend_id] = nil
    if request.post?
      @friend = Friend.authenticate(params[:email], params[:password])
      if @friend
        session[:friend_id] = @friend.id
        redirect_to(:action => "index")
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end
  
  def logout
    session[:friend_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end
  
  def register
  end
  
  def add_user
    @friend = Friend.new(params[:friend])
    if request.post? and @friend.save
      flash.now[:notice] = "User #{@friend.name} created"
      @friend = Friend.new
    end
  end

  # . . .
  
  def list_users
    @all_users = Friend.find(:all)
  end
  
  

end
