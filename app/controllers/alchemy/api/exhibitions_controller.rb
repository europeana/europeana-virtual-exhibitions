module Alchemy
  class Api::ExhibitionsController < Api::BaseController

    # Returns all exhibitions as json object
    #
    def index
      @pages = Page.published.all.where(depth: 2).where(page_layout: 'exhibition_theme_page').order(lft: :desc).limit(100)
      if params[:language].present?
        @pages = @pages.where(language_code: params[:language])
      end
      respond_with @pages
    end
  end
end
