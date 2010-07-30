class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :user_id,	:null => false, :options => "CONSTRAINT fk_content_users REFERENCES		users(id)"
      t.integer :friend_id,	:null => false, :options => "CONSTRAINT fk_content_friends REFERENCES	friends(id)"
      t.string :url,		:null => false
      t.boolean :watched,	:null => false
      t.string :thumbnail_url, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
