# frozen_string_literal: true

Alchemy::Picture.module_exec do
  has_many :dragonfly_signatures, dependent: :destroy

  after_save :process_versions

  def process_versions
    Europeana::PictureVersionsJob.perform_later id
  end
end
