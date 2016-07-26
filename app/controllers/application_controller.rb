class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def relative_url_root
    @relative_url_root ||= Rails.application.config.relative_url_root
  end
end
