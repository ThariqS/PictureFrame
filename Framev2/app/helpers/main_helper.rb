module MainHelper
	
	def rightBtnClass (index,limit)
		@class = (index >= limit) ? "unactiveArchiveBtn": "activeArchiveBtn";
	end
	
	def leftBtnClass (index)
		@class = (index <= 3) ? "unactiveArchiveBtn" : "activeArchiveBtn";
	end
	
	 def uploadvid
	  	@content = Content.new(params[:content])
	  	@user = User.find(params[:id])
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
     end
	
end
