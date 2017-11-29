Alchemy::Picture.module_exec do
  after_save :process_versions

  def process_versions
    Europeana::PictureVersionsJob.perform_later id
  end
end
