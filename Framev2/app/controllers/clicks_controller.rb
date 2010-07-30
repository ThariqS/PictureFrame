class ClicksController < ApplicationController
  # GET /clicks
  # GET /clicks.xml
  def index
  	if (params[:id] == nil)
   		 @clicks = Click.all
   	else 
   		@user = User.find(params[:id])
   		@clicks = @user.clicks
	end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clicks }
    end
  end

  # GET /clicks/1
  # GET /clicks/1.xml
  def show
    @click = Click.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @click }
    end
  end


  # GET /clicks/1/edit
  def edit
    @click = Click.find(params[:id])
  end
  

  # PUT /clicks/1
  # PUT /clicks/1.xml
  def update
    @click = Click.find(params[:id])

    respond_to do |format|
      if @click.update_attributes(params[:click])
        flash[:notice] = 'Click was successfully updated.'
        format.html { redirect_to(@click) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @click.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clicks/1
  # DELETE /clicks/1.xml
  def destroy
    @click = Click.find(params[:id])
    @click.destroy

    respond_to do |format|
      format.html { redirect_to(clicks_url) }
      format.xml  { head :ok }
    end
  end
end
