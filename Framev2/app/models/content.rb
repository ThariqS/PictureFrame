class Content < ActiveRecord::Base
	
	
	belongs_to :user
	belongs_to :friend
	
	has_attached_file :photo, :styles => { 
	:thumb => "128x96"},:url  => "/content/images/:style/:id:basename.:extension",
    :path => ":rails_root/public/content/images/:style/:id:basename.:extension"

	has_attached_file :vid,:url  => "/content/:basename.:extension",
    :path => ":rails_root/public/content/:basename.:extension"


	def thumb_url
		(self.media == "vid") ? "/content/"+self.url+".jpg" : self.photo.url(:thumb);
	end
	
	def convert_vid
	  	if (vid_content_type != "video/x-flv")
  			@videopath = vid.path
			@outputpath =  vid.path.split('.')[0]
			@outputpath.concat('.flv')
			#Need to Force FFMPEG to overwrite file
			%x[ffmpeg -i "#{@videopath}" -y "#{@outputpath}"]
			self.vid_content_type = "video/x-flv"
			self.url = vid_file_name.split('.')[0];
			self.vid_file_name = vid_file_name.split('.')[0].concat('.flv')
		end
	end  
	
	def get_thumbnail (vidpath)
  		@videopath = vidpath
		@thumbpath = "/home/thariqshihipar/Framev2/public/content/"+url+".jpg" 
		%x[ffmpeg -i #{@videopath} -vcodec mjpeg -vframes 1 -an -f rawvideo -s 160x120 -ss 00:00:01 -y #{@thumbpath}]
	end  
	

	

end
