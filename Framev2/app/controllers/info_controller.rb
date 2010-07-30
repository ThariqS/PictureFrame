class InfoController < ApplicationController

  def GetContent
  	@user = User.find(params[:id])
    @contents = @user.contents
    respond_to do |format|
      format.xml  { render :xml => @contents }
    end  	
  end

  def GetPic
  	@user = User.find(params[:id])
    respond_to do |format|
      format.xml  { render :layout => false, :xml => @user.photo.url(:thumb)  }
    end 
  end

  def SendEmail
    @user = User.find(params[:id])
    @user.friends.each do |friend|
		NotifyMailer.deliver_send(friend.id)
	end  
    respond_to do |format|
      format.html # SendEmail.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def MarkWatched
    @content = Content.find(params[:id])
    @content.watched = true;
    @content.save;
	respond_to do |format|
      format.html # MarkWatched.html.erb
      format.xml  { render :xml => @content }
    end
  end
  
  def error
  	NotifyMailer.deliver_error(params[:id],params[:error])
  	
  end
  
 def RecordClick
    @click = Click.new(:user_id => params[:id], :timeclicked => Time.now)
    @click.save
	respond_to do |format|
      format.html # RecordClick.html.erb
      format.xml  { render :xml => @click }
    end
  end
  
end
