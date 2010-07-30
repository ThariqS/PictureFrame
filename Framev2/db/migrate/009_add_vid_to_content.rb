class AddVidToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :vid_file_name, :string # Original filename
    add_column :contents, :vid_content_type, :string # Mime type
    add_column :contents, :vid_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :content, :vid_file_name
    remove_column :content, :vid_content_type
    remove_column :content, :vid_file_size
  end
end