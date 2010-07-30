class ContentsController < ApplicationController
  # GET /contents
  # GET /contents.xml
  
  
  # GET /contents/record
  # GET /contents/record.xml
  
  def index
    @contents = Content.all
 
    respond_to do |format|
      format.html # index.html.erb
      format.fbml # index.fbml.erb
      format.xml  { render :xml => @contents }
    end
  end

  # GET /contents/1
  # GET /contents/1.xml
  def show
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content }
    end
  end
  

  # GET /contents/new
  # GET /contents/new.xml
  def new
  	@user = User.find(params[:id])
    @content = Content.new(	:media => "vid", :watched => false, :user_id => params[:id],
    						:url => @user.name+Time.now.to_i.to_s, :friend_id => session[:friend_id]);

	session[:content] = @content;
	@path = url_for(:controller => 'contents',:action => "save")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content }
    end
  end
  
  def save
    @content = session[:content];
    @user = User.find(@content.user_id);
    @user.contents << @content;
	if (@content.save && @user.save)
		flash[:notice] = "Your video has been sent.";
		@content.get_thumbnail("/usr/local/WowzaMediaServer-2.0.0/content/"+@content.url+".flv")
		redirect_to(:controller => 'users',:action => 'menu', :id => @content.user_id );
		session.data.delete :content
	else
		flash[:notice] = "There was an error uploading the video, please try again.";
		redirect_to(:controller => 'main',:action => 'index');
	end
  end
  
  def upload
  	@content = Content.new(params[:content])
  	@user = User.find(params[:id])
  	if (@content.photo_file_name != nil)
  		
  		@content.update_attributes(:media => "pic", :watched => false, :user_id => params[:id],
    								:url => @content.photo_file_name, :friend_id => session[:friend_id]);	

  		if (@content.save)
  			redirect_to(:controller => 'main',:action => 'index');
  		else
  			flash[:notice] = "There was an error uploading the photo, please try again.";
  		end
  	else
    	respond_to do |format|
      		format.html # upload.html.erb
      		format.xml  { render :xml => @content }
		end
    end
  end
  
  def uploadvid
  	@content = Content.new(params[:content])
  	@user = User.find(params[:id])
  	if (@content.vid_file_name != nil)
  		
  		@content.update_attributes(	:media => "vid", :watched => false, :user_id => params[:id],
    								:url => "", :friend_id => session[:friend_id]);	
  		
  		if (@content.save)
  			@content.convert_vid
  			@content.get_thumbnail(@content.vid.path)
  			@content.save
  			redirect_to(:controller => 'main',:action => 'index');
  		else
  			flash[:notice] = "There was an error uploading the video, please try again.";
  		end
  	else

    	respond_to do |format|
      		format.html # uploadvid.html.erb
      		format.xml  { render :xml => @content }
		end
    end
  end
 

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
  end
  

  # PUT /contents/1
  # PUT /contents/1.xml
  def update
    @content = Content.find(params[:id])
    respond_to do |format|
      if @content.update_attributes(params[:content])
        flash[:notice] = 'Content was successfully updated.'
        format.html { redirect_to(@content) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.xml
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to(contents_url) }
      format.xml  { head :ok }
    end
  end
  
  
end
