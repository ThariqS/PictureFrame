# /config/initializers/mailer.rb

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls  => true,
  :address 	=> "smtp.gmail.com",
  :port 	=> 587,
  :domain	=> "mail.taglab.ca",
  :authentication	=> :login,
  :user_name	=> "thariq@taglab.ca",
  :password		=> "kmdi12"
}