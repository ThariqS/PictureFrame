class User < ActiveRecord::Base
	has_many :friends
	has_many :contents
end
