module Europeana
  class Page
    include ActionView::Helpers::TagHelper
    include Rails.application.routes.url_helpers

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


    def chapter_elements
      if !is_exhibition
        return {present: false, item: []}
      end
      {
        present: true,
        items: exhibition.descendants.map.with_index do |page, index|
          Europeana::Page.new(page).as_chapter
        end
      }
    end

    def credit_elements
      if !is_credit
        return { present: false, items: []}
      end
      {
        present: true,
        items: exhibition.self_and_descendants.map.with_index do |page, index|
          Europeana::Page.new(page).media
        end.flatten
      }
    end

    def media
      @page.elements.published.where(name: ['image', 'rich_image', 'intro']).map do |element|

        Europeana::Elements::Base.build(element).to_hash(include_url: url)
      end
    end

    def as_chapter
      {
        is_chapter_nav: true,
        title: @page.title,
        url: show_page_url(@page.language_code, @page.urlname),
        label: find_thumbnail ? find_thumbnail[:label] : false,
        image: find_thumbnail ? find_thumbnail[:image] : false
      }
    end

    def is_chapter
      @page.depth >= 3
    end

    def is_exhibition
      @page.depth == 2
    end

    def is_foyer
      @page.depth == 1
    end

    def is_credit
      @page.page_layout == 'exhibition_credit_page'
    end

    def meta_tags
      robots_tag
    end

    def link_tags
      language_alternatives_tags
    end

    def exhibition
      @exhibition ||= (@page.depth == 1 ? @page : @page.self_and_ancestors.where(depth: 2).first)
    end

    def table_of_contents
      exhibition.descendants
    end

    def chapters
      exhibition.descendants
    end

    def title
      @page.title
    end

    def url
      show_page_url(@page.language_code, @page.urlname)
    end


    def menu_data
      {
        text: exhibition.title,
        url: '#',
        submenu: {
            items: chapters.collect do |chapter|
            {
              text: chapter.title,
              url: show_page_url(urlname: chapter.urlname, locale: chapter.language_code)
            }
            end
        }
      }
    end

    def find_thumbnail
      element = @page.elements.published.where(name: 'intro').first
      return Europeana::Elements::ChapterThumbnail.new(element).to_hash if element

      element = @page.elements.published.where(name: ['image', 'rich_image', 'credit_intro']).first
      return Europeana::Elements::ChapterThumbnail.new(element).to_hash if element
      false
    end

    def alternatives
      Alchemy::Page.published.where.not(language_code: @page.language_code).where(urlname: @page.urlname).all
    end

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

      { meta_name: 'robots', content: content.join(',')}
    end

    def language_alternatives_tags
      alternatives.collect do |page|
        { rel: 'alternate', hreflang: page.language_code, href: page.urlname, title: nil}
      end
    end

    def language_default_link
      [{ rel: 'alternate', hreflang: 'x-default', href: url, title: nil}]
    end

    # meta information
    def description
      element = @page.find_elements(only: ['intro', 'text', 'rich_image']).first
      if element
        element = Europeana::Elements::Base.build(element).get(:body, :stripped_body)
      end
      return element if element
      return @page.title
    end

    def thumbnail(version = :full)
      if find_thumbnail && find_thumbnail.has_key?(:image) && find_thumbnail[:image]
        return full_url(find_thumbnail[:image][version][:url])
      end
      false
    end

    def full_url(path)
      "http://#{ENV.fetch('CDN', 'cdn')}#{ENV.fetch('APP_PORT', nil).nil? ? '' : ':'+ ENV.fetch('APP_PORT', nil)}#{path}"
    end
  end
end
