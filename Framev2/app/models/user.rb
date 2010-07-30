class User < ActiveRecord::Base

	has_many :friends
	has_many :contents
	has_many :clicks
	
	has_attached_file :photo, :styles => { 
	:thumb => "128x96"},:url  => "/frameimages/:id/:style/:basename.:extension",
    :path => ":rails_root/public/frameimages/:id/:style/:basename.:extension"
    
    has_attached_file :profilepic, :styles => { 
	:thumb => "128x96"},:url  => "/profile_pics/:id/:style/:basename.:extension",
    :path => ":rails_root/public/profile_pics/:id/:style/:basename.:extension"

end
