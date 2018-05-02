# frozen_string_literal: true

module Europeana
  class PictureVersionsCleanupJob < ActiveJob::Base
    queue_as :default
    include PictureVersionHelper

    def perform(id)
      %w(halfx2 small smallx2 thumbnailx2 thumbnail_png).each do |version_key|
        signature = Alchemy::DragonflySignature.find_by(picture_id: id, version_key: version_key)
        signature.delete if signature # Delete to skip callbacks, orphaned versions should be cleaned up separately.
      end
    end
  end
end
