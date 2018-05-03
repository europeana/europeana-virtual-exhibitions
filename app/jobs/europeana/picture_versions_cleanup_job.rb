# frozen_string_literal: true

module Europeana
  class PictureVersionsCleanupJob < ActiveJob::Base
    queue_as :default
    include PictureVersionHelper

    # These jobs will be ran in order to remove duplicate signatures for differnet version keys.
    # Once all of these signatures have been removed the job won't be needed anymore and can be removed.
    #
    def perform(id)
      %w(halfx2 small smallx2 thumbnailx2 thumbnail_png).each do |version_key|
        signature = Alchemy::DragonflySignature.find_by(picture_id: id, version_key: version_key)
        signature&.delete # Delete to skip callbacks, orphaned versions should be cleaned up separately.
      end
    end
  end
end
