class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.integer :user_id,	:null => false, :options => "CONSTRAINT fk_friend_users REFERENCES		users(id)"
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :image_url
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
