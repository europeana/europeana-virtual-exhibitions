# frozen_string_literal: true

module Alchemy
  class PictureVersion < ActiveRecord::Base
    has_one :dragonfly_signature, foreign_key: :signature, primary_key: :signature
    attr_writer :image

    before_destroy :remove_from_store

    def self.from_cache(image)
      (find_by_signature(image.signature) || new).tap do |record|
        record.image = image
      end
    end

    def image
      @image ||= image_from_db
    end

    def data
      if new_record?
        store_and_save!(image).data
      else
        content = image.app.datastore.read(file_uuid)
        if content.nil?
          store_and_save!(image).data
        else
          content.first
        end
      end
    end

    private

    def store_and_save!(image)
      self.file_uuid = image.store(path: "versions/#{image.signature}/#{image.name}")
      self.signature = image.signature
      save
      image
    end

    def remove_from_store
      Dragonfly.app(:alchemy_pictures).datastore.destroy(file_uuid)
    end
  end
end
