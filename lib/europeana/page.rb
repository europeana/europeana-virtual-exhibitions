module Europeana
  class Page
    include ActionView::Helpers::TagHelper

    def initialize(page)
      @page = page
    end

    def elements
      {
        present: @page.elements.published.where.not(name: 'chapter').count >= 1,
        items: @page.elements.published.where.not(name: 'chapter').map.with_index do |element, index|
          {
            is_last: index == (@page.elements.published.count - 1),
            is_first: index == 0,
            is_full_section_element: section_element_count[element.id] == 1
          }.merge(Europeana::Elements::Base.build(element).to_hash)
        end
      }
    end

    def head_tags
      [
        meta_tags,
        link_tags
      ].flatten
    end

    def meta_tags
      robots_tag
    end

    def link_tags
      language_alternatives_tags
    end



    private
    def section_element_count
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

    def robots_tag
      content = []
      content << (@page.robot_index? ? 'index' : 'noindex')
      content << (@page.robot_follow? ? 'follow' : 'nofollow')

      tag(:meta, name: 'robots', content: content.join(','))
    end

    def language_alternatives_tags
      Alchemy::Page.published.where.not(language_code: @page.language_code).where(urlname: @page.urlname).all.collect do |page|
        tag(:link, { rel: :alternate, hreflang: page.language_code, href: page.urlname})
      end
    end

  end
end
