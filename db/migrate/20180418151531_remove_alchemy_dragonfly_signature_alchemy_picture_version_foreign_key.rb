# frozen_string_literal: true

class RemoveAlchemyDragonflySignatureAlchemyPictureVersionForeignKey < ActiveRecord::Migration
  def up
    remove_foreign_key :alchemy_dragonfly_signatures, column: :signature
  end

  def down
    add_foreign_key :alchemy_dragonfly_signatures, :alchemy_picture_versions, column: :signature, primary_key: 'signature'
  end
end
