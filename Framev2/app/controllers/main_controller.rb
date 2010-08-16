class MainController < ApplicationController
	
  def index
  	if (Friend.exists?(session[:friend_id]))
  		@friend = Friend.find(session[:friend_id]);
  		redirect_to(:action => 'menu', :id => @friend.user_id );
  	else
  		redirect_to(:action => "login")
  	end
  end
  
  def login
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
  
    # GET /main/1/menu
  def menu
    @user = User.find(params[:id])
    @friend = Friend.find(session[:friend_id])
     session[:content_index] = 3;
    @contents = @user.contents.find(:all, :offset => @user.contents.length - session[:content_index], :limit => 3)
   #NotifyMailer.deliver_send(session[:friend_id])
	respond_to do |format|
      format.html # menu.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  
  def next_pic
	@user = User.find(params[:id])
	@dir = params[:dir]
	if (@dir == "1" and session[:content_index] < @user.contents.length)
		session[:content_index] = session[:content_index] + 3
	end
	else if (@dir == "-1" and session[:content_index] > 3)
		session[:content_index] = session[:content_index] - 3
	end
	@contents = @user.contents.find(:all, :offset => (@user.contents.length - session[:content_index]), :limit => 3)
	respond_to do |format|
		format.js
	end

end

  # . . .
  
  def list_users
    @all_users = Friend.find(:all)
  end
  
  

end
