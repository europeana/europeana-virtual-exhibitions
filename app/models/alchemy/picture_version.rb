class Alchemy::PictureVersion < ActiveRecord::Base
  has_one :alchemy_dragonfly_signature, class_name: 'Alchemy::DragonflySignature', foreign_key: :signature,
                                          primary_key: :signature, dependent: :destroy
  attr_accessor :image

  before_destroy :remove_from_store

  def self.from_cache(image)
    record = self.find_by_signature(image.signature)
    record.nil? ? Alchemy::PictureVersion.new(image: image) : (record.image = image; record)
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
    self.save
    image
  end

  def remove_from_store
    Dragonfly.app(:alchemy_pictures).datastore.destroy(file_uuid)
  end
end
