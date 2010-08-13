module UsersHelper
	
	def hidden_div_if(condition,attributes = {}, &block)
		if condition
			attributes["style"] = "display: none"
			attributes["class"] = "unactiveArchiveBtn"
		else
			attributes["class"] = "activeArchiveBtn"
		end
		content_tag("div",attributes,&block)
	end
	
	def leftBtnClass (index)
		@class = (index < 3) ? "unactiveArchiveBtn": "activeArchiveBtn";
	end
	
	def rightBtnClass (index,limit)
		@class = (index > limit) ? "unactiveArchiveBtn" : "activeArchiveBtn";
	end
	
	
end
