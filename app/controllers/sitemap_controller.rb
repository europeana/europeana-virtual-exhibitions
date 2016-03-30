class SitemapController < ApplicationController
  def robots
    render text: 'robots.txt'
  end

  def index
    @languages = Alchemy::Language.all
  end

  def show
    @language = Alchemy::Language.where(language_code: params[:locale]).first
    if @language
      @pages = @language.pages.published
    end
  end
end
