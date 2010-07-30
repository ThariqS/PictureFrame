class UpdateFriends < ActiveRecord::Migration
  def self.up
    add_column :friends, :gender, :string
	add_column :friends, :relationship, :string
  end

  def self.down
    remove_column :friends, :gender
  	remove_column :friends, :relationship
	end
end