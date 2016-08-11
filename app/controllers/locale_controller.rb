# frozen_string_literal: true
class LocaleController < ApplicationController
  def index
    redirect_to show_page_path(locale: I18n.locale, urlname: 'foyer')
  end

  protected

  def enforce_locale?
    false
  end
end
