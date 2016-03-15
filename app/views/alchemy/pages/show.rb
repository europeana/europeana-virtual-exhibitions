module Alchemy::Pages
  class Show < Europeana::Styleguide::View
    include MustacheHelper

    def elements
      {
        present: @page.elements.published.count >= 1,
        items: @page.elements.published.map.with_index do |element, index|
          {
            is_last: index == (@page.elements.published.count - 1),
            is_first: index == 0,
            is_full_section_element: element_sections[element.id] == 1
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
        breakpoint_pixels: breakpoint_pixels,
        css_files: nil,
        page: page_data
      })
    end

    def debug_mode
      params.include?(:debug)
    end


    private
    def element_sections
      if @elements_sections.nil?
        @sections = []
        current_index = 0
        @sections[current_index] = []
        @page.elements.published.each do | element |
          if element.name != 'section'
            @sections[current_index] << element.id
          else
            current_index = current_index.next
            @sections[current_index] = []
          end
        end
        @elements_sections = {}
        @sections.each do |section|
          count = section.length
          section.each do |element|
            @elements_sections[element] = count
          end
        end
      end
      @elements_sections
    end
  end
end
