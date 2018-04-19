# frozen_string_literal: true

Alchemy::Picture.module_exec do
  # Dragonfly signatures are generated in the PictureVersionsJob for each 'picture_version'. To remove a picture
  # version, the dragonfly signature can be deleted and the version will thereby cascade delete.
  has_many :dragonfly_signatures, dependent: :destroy

  after_save :process_versions

  def process_versions
    Europeana::PictureVersionsJob.perform_later id
  end
end
