class CreateAlchemyPictureVersions < ActiveRecord::Migration
  def change
    create_table :alchemy_picture_versions do |t|
      t.references :picture
      t.string :signature, null: false
      t.string :file_uuid, null: false
      t.timestamps null: false
    end
  end
end
