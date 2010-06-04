require 'Time'

class ContentsController < ApplicationController
  # GET /contents
  # GET /contents.xml
  
  
  # GET /contents/record
  # GET /contents/record.xml
  def record
    @content = Content.new
    respond_to do |format|
      format.html # record.html.erb
      format.xml  { render :xml => @content }
    end
  end
  
  
  def index
    @contents = Content.all
 
    respond_to do |format|
      format.html # index.html.erb
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
  
  def save
    @content = session[:content];
    @user = User.find(@content.user_id);
    @user.contents << @content;
	if (@content.save && @user.save)
		flash[:notice] = "Your video has been sent.";
		redirect_to(:controller => 'users',:action => 'menu', :id => @content.user_id );
		session.data.delete :content
	end
  end

  # GET /contents/new
  # GET /contents/new.xml
  def new
  	@user = User.find(params[:id])
    @content = Content.new;
	@content.watched = false;
	@content.user_id = params[:id];
	@content.url = "vid"+Time.now.to_i.to_s;
	@content.friend_id = params[:id]; #SHOULD BE CHANGED TO REFLECT THE LOGIN SESSION  DATA
	@content.thumbnail_url = @content.url+".jpg";
	@g = @content.url;
	session[:content] = @content;

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
  end
  
  
    # GET /users/watched/1
  def watched
    @content = Content.find(params[:id])
    @content.watched = true;
    @content.save;
	respond_to do |format|
      format.html # watched.html.erb
      format.xml  { render :xml => @content }
    end
  end
  

  # POST /contents
  # POST /contents.xml
  def create
    @content = Content.new(params[:content])

    respond_to do |format|
      if @content.save
        flash[:notice] = 'Content was successfully created.'
        format.html { redirect_to(@content) }
        format.xml  { render :xml => @content, :status => :created, :location => @content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
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
