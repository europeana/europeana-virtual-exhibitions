module LocalisedRoutes
  extend ActiveSupport::Concern

  included do
    before_action :determine_locale, if: :determine_locale?
    before_action :enforce_locale, if: :enforce_locale?
  end

  protected

  def determine_locale
    session[:locale] = params[:locale] if params.key?(:locale)
    session[:locale] ||= extract_locale_from_accept_language_header
    session[:locale] ||= I18n.default_locale

    unless I18n.available_locales.map(&:to_s).include?(session[:locale].to_s)
      unknown_locale = session.delete(:locale)
      fail ActionController::RoutingError, "Unknown locale #{unknown_locale}"
    end

    I18n.locale = session[:locale]
  end

  def determine_locale?
    true
  end

  def enforce_locale
    redirect_to add_locale_to_path(request.original_fullpath, I18n.locale)
  end

  def enforce_locale?
    !params.key?(:locale)
  end

  def extract_locale_from_accept_language_header
    return unless request.env.key?('HTTP_ACCEPT_LANGUAGE')
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def add_locale_to_path(path, locale)
    if relative_url_root.present?
      path.sub(/\A#{relative_url_root}/, "#{relative_url_root}/#{locale}")
    elsif path == '/'
      "/#{locale}"
    else
      "/#{locale}#{path}"
    end
  end

  def relative_url_root
    @relative_url_root ||= Rails.application.config.relative_url_root
  end
end
