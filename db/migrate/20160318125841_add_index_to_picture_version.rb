class AddIndexToPictureVersion < ActiveRecord::Migration
  def change
    add_index :alchemy_picture_versions, [:signature], :unique => true
  end
end
