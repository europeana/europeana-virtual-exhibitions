class LocaleController < ApplicationController
  def index
    redirect_to show_page_path(locale: I18n.locale, urlname: 'foyer')
  end

  def show
    redirect_to add_locale_to_path(request.original_fullpath, I18n.locale)
  end

  private

  def add_locale_to_path(path, locale)
    if relative_url_root.present?
      path.sub(/\A#{relative_url_root}/, "#{relative_url_root}/#{locale}")
    elsif path == '/'
      "/#{locale}"
    else
      "/#{locale}#{path}"
    end
  end
end
