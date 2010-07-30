class RemoveThumbnailFromContent < ActiveRecord::Migration
  def self.up
    remove_column :contents, :thumbnail_url
  end

  def self.down
    add_column :content, :media, :string
  end
end