#Alchemy::Picture.class_eval do
#  after_save :process_versions
#
#  def process_versions
#    Europeana::PictureVersionsJob.perform_later id
#  end
#end
