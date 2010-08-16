module MainHelper
	
	def rightBtnClass (index,limit)
		@class = (index >= limit) ? "unactiveArchiveBtn": "activeArchiveBtn";
	end
	
	def leftBtnClass (index)
		@class = (index <= 3) ? "unactiveArchiveBtn" : "activeArchiveBtn";
	end
	
end
