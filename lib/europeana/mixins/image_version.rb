# frozen_string_literal: true

module Europeana
  module Mixins
    module ImageVersion
      include PictureVersionHelper

      # Hash that defines which versions of an image are
      # available and will be created on upload

      # The key is the name of the version and the value is
      # a simple hash with the following keys:
      # size: nil|100x100
      # format: jpeg|png
      # quality: nil|85 (jpeg quality)
      # crop: true if the image can be cropped
      # upsample: true if you want the image to use the entire canvas
      VERSIONS = {
        original: { size: nil, format: 'jpeg', quality: nil },
        full: { size: '1600x1600', format: 'jpeg', quality: 85 },
        fullx2: { size: '3200x3200', format: 'jpeg', quality: 85 },
        half: { size: '800x800', format: 'jpeg', quality: 85 },
        thumbnail: { size: '400x400', format: 'jpeg', quality: 85 },
        facebook: { size: '1200x630', format: 'jpeg', quality: 85, crop: true, upsample: true },
        twitter: { size: '750x560', format: 'jpeg', quality: 85, crop: true, upsample: true }
      }.freeze

      def versions(name = 'image')
        @versions ||= {}
        @versions[name.to_sym] ||= begin
          image = @element.content_by_name(name)
          if image&.essence&.picture.present?
            picture = image.essence.picture
            version_uuid_pairs(picture.id).map { |key, uuid| [key.to_sym, { url: picture_version_url(uuid) }] }.to_h
          else
            false
          end
        end
      end

      ##
      # Queries the Database for file_uuids of picture versions.
      # Since the alchemy_picture_versions table doesn't contain version keys,
      # this method queries by joining it to the alchemy_dragonfly_siganture table which does.
      # Returns the plucked keys and file_uuids as an array of arrays.
      # [['key1','file_uuid1'],['key2','file_uuid2'],...]
      #
      # @param picture_id [#to_s] The id of the picture whose version's file_uuids will be returned
      # @return Array<Array<String, String>>
      def version_uuid_pairs(picture_id)
        signature_criteria = { picture_id: picture_id, version_key: VERSIONS.keys }
        Alchemy::PictureVersion.with_signature.where(alchemy_dragonfly_signatures: signature_criteria).
          pluck('alchemy_dragonfly_signatures.version_key', :file_uuid)
      end
    end
  end
end
