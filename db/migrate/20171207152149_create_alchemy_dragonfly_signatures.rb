# frozen_string_literal: true

class CreateAlchemyDragonflySignatures < ActiveRecord::Migration
  def up
    return if table_exists?(:alchemy_dragonfly_signatures)
    create_table 'alchemy_dragonfly_signatures' do |t|
      t.integer  'picture_id',            null: false
      t.string   'version_key',           null: false
      t.string   'signature',             null: false
      t.timestamps                        null: false
    end

    add_index :alchemy_dragonfly_signatures, %i(picture_id version_key), unique: true,
              :name => 'index_signatures_on_picture_id_and_versions_key'
    add_foreign_key :alchemy_dragonfly_signatures, :alchemy_pictures, column: :picture_id
    add_foreign_key :alchemy_dragonfly_signatures, :alchemy_picture_versions, column: :signature, primary_key: 'signature'
  end

  def down
    drop_table(:alchemy_dragonfly_signatures)
  end
end
