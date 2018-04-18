# frozen_string_literal: true

module Alchemy
  class DragonflySignature < ActiveRecord::Base
    # DragonflySignatures link pictures to their versions. The signatures are generated in the PictureVersionsJob.
    # There's an index on 'picture_id & version_key' for retrieving specific signatures and
    # through them the desired version.
    belongs_to :picture
    belongs_to :picture_version, foreign_key: :signature, primary_key: :signature, dependent: :destroy
    validates_presence_of :picture_id, :version_key, :signature
  end
end
