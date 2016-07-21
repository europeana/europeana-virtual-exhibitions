module Alchemy
  # Handles locale redirects
  #
  # If the current URL has a locale prefix, but should not have one it redirects
  # to url without locale prefix.
  #
  # Situations we don't want a locale prefix:
  #
  # 1. If only one language is published
  # 2. If the requested locale is the current default locale
  #
  module LocaleRedirects
    extend ActiveSupport::Concern

    included do
      before_action :enforce_locale,
        only: [:index, :show]
    end

    private

    # Redirects to requested action without locale prefixed
    def enforce_locale
      # If we are missing a locale send clients to a url with locale
      unless params.include?(:locale)
        redirect_permanently_to Rails.application.routes.url_helpers.show_page_url(urlname: params[:urlname], locale: :en) and return
      end
      # If we get the messed up Alchemy URL
      if request.path.split("/")[2] == "exhibitions"
        redirect_permanently_to Rails.application.routes.url_helpers.show_page_url(urlname: params[:urlname], locale: params[:locale]) and return
      end
    end
  end
end
