module Alchemy
  class PageSerializer < ActiveModel::Serializer
    self.root = false

    attributes :title, :language, :url


    def language
      object.language_code
    end

    def url
      if object.language_code && object.urlname
        show_page_url(object.language_code, object.urlname)
      end
    end
  end
end
