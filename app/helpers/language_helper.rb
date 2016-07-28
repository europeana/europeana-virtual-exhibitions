module LanguageHelper
  def url_without_locale(url, locale: I18n.locale)
    url.sub("/#{locale}", '')
  end

  def current_url_without_locale
    url_without_locale(url_for(params.merge(only_path: false)))
  end
end
