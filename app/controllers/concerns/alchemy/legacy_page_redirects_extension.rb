# frozen_string_literal: true
module Alchemy
  LegacyPageRedirects.module_exec do
    def legacy_urls
      # This method is being overridden to take the urlname from the params instead of the request's fullpath
      urlname = params['urlname']
      LegacyPageUrl.joins(:page).where(
        urlname: urlname,
        Page.table_name => {
          language_id: Language.current.id
        }
      )
    end
  end
end
