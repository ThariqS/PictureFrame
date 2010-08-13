class UsersController < ApplicationController
  
	
	
	# GET /users
  # GET /users.xml
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  # GET /users/1/menu
  def menu
    @user = User.find(params[:id])
    @friend = Friend.find(session[:friend_id])
    @contents = @user.contents.find(:all, :offset => @user.contents.length - 3, :limit => 3)
    session[:content_index] = 0;
   #NotifyMailer.deliver_send(session[:friend_id])
	respond_to do |format|
      format.html # menu.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  
  def next_pic
	@user = User.find(params[:id])
	@dir = params[:dir]
	if (@dir == "1")
		session[:content_index] = session[:content_index] + 3
	else
		session[:content_index] = session[:content_index] - 3
	end
	@contents = @user.contents.find(:all, :offset => (@user.contents.length - session[:content_index]), :limit => 3)
	respond_to do |format|
		format.js
	end
	rescue ActiveRecord::RecordNotFound
	logger.error("Attempttoaccessinvalidproduct#{params[:id]}")
	redirect_to_index("Invalidproduct")
end
 
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def new
  	@user = User.new(params[:user])
  	if (@user.photo_file_name != nil)
  		if (@user.save)
  			redirect_to(:controller => 'main',:action => 'index');
  		else
  			flash[:notice] = "There was an error uploading the user, please try again.";
  		end
  	else
    	respond_to do |format|
      		format.html # new.html.erb
      		format.xml  { render :xml => @user }
		end
    end
  end
  
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  
  # GET /users/1/edit
  def add_friend
    redirect_to(:controller => 'friends',:action => 'new', :id => params[:id] );
  end


  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
   before_filter :authorize
	
	protected
		def authorize
			unless Friend.find_by_id(session[:friend_id])
			redirect_to :controller => 'main', :action => 'login'
		end
	end


end
