class AddUserToClicks < ActiveRecord::Migration
  def self.up
    add_column :clicks, :user_id, :integer, :options => "CONSTRAINT fk_clicks_users REFERENCES users(id)"
  end

  def self.down
    remove_column :clicks, :user_id
  end
end