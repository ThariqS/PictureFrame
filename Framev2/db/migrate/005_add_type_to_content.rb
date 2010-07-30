class AddTypeToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :media, :string 
  end

  def self.down
    remove_column :content, :media
  end
end