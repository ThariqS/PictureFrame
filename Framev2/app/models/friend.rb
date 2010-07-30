class Friend < ActiveRecord::Base
	
	belongs_to :user
	has_many :contents
	
	validates_presence_of	:name
	validates_uniqueness_of	:name
	
	attr_accessor :password_confirmation
	validates_confirmation_of :password
	
	validate :password_non_blank

  def self.authenticate(email, password)
    friend = self.find_by_email(email)
    if friend
      expected_password = encrypted_password(password, friend.salt)
      if friend.hashed_password != expected_password
        friend = nil
      end
    end
    friend
  end
  
  # 'password' is a virtual attribute
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    #create_new_salt
    self.salt = self.object_id.to_s + rand.to_s;
    #salt = name + rand.to_s;
    self.hashed_password = Friend.encrypted_password(self.password, self.salt)
  end
  
  private
  
  def password_non_blank
  		errors.add(:password,"Missing password") if self.hashed_password.blank?
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt  # 'wibble' makes it harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end
 
  #def create_new_salt
  #  self.salt = self.object_id.to_s + rand.to_s
  #end
	
end
