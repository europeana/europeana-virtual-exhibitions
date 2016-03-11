module Alchemy::Pages
  class Show < Europeana::Styleguide::View
    include MustacheHelper

    def elements
      {
        present: @page.elements.published.count >= 1,
        items: @page.elements.published.map.with_index do |element, index|
          {
            is_last: index == (@page.elements.published.count - 1),
            is_first: index == 0
          }.merge(Europeana::Elements::Base.build(element).to_hash)
        end
      }
    end

    def page_data
      {
        elements: elements,
        title: @page.title,
        url: show_page_url(nil, @page.urlname)
      }
    end

    def json
      JSON.pretty_generate({
        js_files: js_files,
        head_links: head_links,
        bp_px: bp_px,
        css_files: nil,
        page: page_data
      })
    end

    def debug_mode
      params.include?(:debug)
    end
  end
end
