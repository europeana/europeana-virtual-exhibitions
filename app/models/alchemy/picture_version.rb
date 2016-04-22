class Alchemy::PictureVersion < ActiveRecord::Base
  attr_accessor :image

  def self.from_cache(image)
    record = find_by_signature(image.signature)
    record.nil? ? Alchemy::PictureVersion.new(image: image) : (record.image = image; record)
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
end
