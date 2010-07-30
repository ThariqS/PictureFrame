class NotifyMailer < ActionMailer::Base
  
  def send(friend_id)
  	@friend = Friend.find(friend_id)
  	@user = User.find(@friend.user_id);
    subject    'A relative is thinking of you'
    recipients @friend.email
    from       'memories.in.touch@taglab.ca'
    sent_on    Time.now
    
    body       :greeting => 'Hi,'
  end
  
  def invite(sent_at = Time.now)
    subject    'NotifyMailer#invite'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end
  
  def error(user_id,errormsg)
  	@user = User.find(user_id)
  	@error = errormsg
    subject    '[TAG] Error Message'
    recipients 'trq212@gmail.com'
    from       'memories.in.touch@taglab.ca'
    sent_on    Time.now
    
    body       :greeting => 'Hi,'
  end
  
  
  

end
