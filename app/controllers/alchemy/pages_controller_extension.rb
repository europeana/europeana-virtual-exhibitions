# frozen_string_literal: true

Alchemy::PagesController.module_exec do
  ##
  # Extends the render_page method in order to allow json responses.
  #
  def render_page
    respond_to do |format|
      format.html do
        render action: :show, layout: !request.xhr?
      end

      format.rss do
        if @page.contains_feed?
          render action: :show, layout: false, handlers: [:builder]
        else
          render xml: {error: 'Not found'}, status: 404
        end
      end

      format.json do
        render action: :show, layout: false
      end
    end
  end
end
