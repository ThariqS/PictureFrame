 class ChangeProfilepicUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :profilepic_file_name, :string # Original filename
    add_column :users, :profilepic_content_type, :string # Mime type
    add_column :users, :profilepic_file_size, :integer # File size in bytes
    remove_column :users, :image_url
    remove_column :users, :dir
  end

  def self.down
    remove_column :user, :profilepic_file_name
    remove_column :user, :profilepic_content_type
    remove_column :user, :profilepic_file_size
    add_column :user, :image_url, :string
    add_column :user, :dir, :string
  end
end
