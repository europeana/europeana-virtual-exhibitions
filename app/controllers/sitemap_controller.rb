class SitemapController < ApplicationController

  before_action :find_language, only: [:feed, :show]

  def robots
    render text: 'robots.txt'
  end

  def index
    @languages = Alchemy::Language.all
  end

  def feed
    @pages = @language.pages.where(depth: 2).published.order('published_at DESC').limit(25)
  end

  def show
    @pages = @language.pages.published
  end

  private

  def find_language
    @language = Alchemy::Language.where(language_code: params[:locale]).first
    raise ActionController::RoutingError.new('Not Found') unless @language
  end
end
