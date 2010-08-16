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

	
	
end
