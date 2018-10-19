# frozen_string_literal: true

Alchemy::PagesController.module_exec do
  alias :render_page_default :render_page

  def render_page
    if request.format == Mime::JSON
      respond_to do |format|
        format.json do
          @page_object = Europeana::Page.new(@page)
          render action: :show, layout: false
        end
      end
    else
      render_page_default
    end
  end
end
