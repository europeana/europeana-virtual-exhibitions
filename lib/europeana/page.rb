module Europeana
  class Page
    include ActionView::Helpers::TagHelper
    include Rails.application.routes.url_helpers
    include LanguageHelper

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
      {
        present: true,
        items: chapters.map.with_index do |page, index|
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
        end.flatten.compact
      }
    end

    def media
      @page.elements.published.where(name: ['image', 'rich_image', 'intro']).map do |element|
        element = Europeana::Elements::Base.build(element)
        next if element.hide_in_credits
        element.to_hash(include_url: url)
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
      chapters
    end

    def chapters
      exhibition.descendants
    end

    def all_pages
      if exhibition
        return exhibition.self_and_descendants
      end
      return [@page]
    end

    def title
      @page.title
    end

    def url
      @url ||= show_page_url(locale: @page.language_code, urlname: @page.urlname)
    end

    def breadcrumbs
      crumbs = @page.self_and_ancestors.where('depth >= 1').map do |ancestor|
        {
          url: show_page_url(@page.language_code, ancestor.urlname),
          title: ancestor.title
        }
      end
      # Set the index page's breadcrumb title to locale specific string.
      crumbs[0][:title] = I18n.t('site.navigation.breadcrumb.exhibitions.return_home', default: 'Exhibitions')
      crumbs = prepend_portal_breadcrumb crumbs
      crumbs.last[:is_last] = true
      crumbs
    end

    ##
    # All this logic expcept for the exhibition related
    # elements come from the europeana collection portal.
    # TODO: This should be refactored to link into the portal's menu data more directly.
    #
    def menu_data
      [
        {
          text: I18n.t('global.navigation.collections'),
          is_current: false,
          submenu: {
            items: navigation_global_primary_nav_collections_submenu_items
          }
        },
        {
          text: I18n.t('global.navigation.browse'),
          is_current: false,
          submenu: {
            items: navigation_global_primary_nav_browse_submenu_items
          }
        },
        {
          text: exhibition.title,
          url: '#',
          is_current: true,
          submenu: {
            items: menu_items.map do |chapter|
              {
                text: chapter.title,
                url: show_page_url(urlname: chapter.urlname, locale: chapter.language_code),
                is_current: chapter == @page,
                submenu: false
              }
            end
          }
        },
        {
          url: 'http://blog.europeana.eu/',
          text: I18n.t('global.navigation.blog'),
          submenu: {
            items: navigation_global_primary_nav_blog_submenu_items
          }
        }
      ]
    end

    ##
    # Support method for menu_data, remove upon refactor.
    #
    def navigation_global_primary_nav_collections_submenu_items
      [
        link_item('Art', URI.join(europeana_collections_url, 'collections/art'), is_current: false),
        link_item('Fashion', URI.join(europeana_collections_url, 'collections/fashion'), is_current: false),
        link_item('Music', URI.join(europeana_collections_url, 'collections/music'), is_current: false)
      ]
    end

    ##
    # Support method for menu_data, remove upon refactor.
    #
    def navigation_global_primary_nav_browse_submenu_items
      [
        link_item(I18n.t('global.navigation.browse_newcontent'), URI.join(europeana_collections_url, 'explore/newcontent'),
                  is_current: false),
        link_item(I18n.t('global.navigation.browse_colours'), URI.join(europeana_collections_url, 'explore/colours'),
                  is_current: false),
        link_item(I18n.t('global.navigation.browse_sources'), URI.join(europeana_collections_url, 'explore/sources'),
                  is_current: false),
        link_item(I18n.t('global.navigation.concepts'), URI.join(europeana_collections_url, 'explore/topics'),
                  is_current: false),
        link_item(I18n.t('global.navigation.agents'), URI.join(europeana_collections_url, 'explore/people'),
                  is_current: false),
        navigation_global_primary_nav_galleries
      ]
    end

    ##
    # Support method for menu_data, remove upon refactor.
    #
    def navigation_global_primary_nav_blog_submenu_items
      # Commented out individual blog posts for now to avoid having to port
      # even more code from the collections portal.

      # feed_items = feed_entry_nav_items(Cache::FeedJob::URLS[:blog][:all], 6)
      [link_item(I18n.t('global.navigation.all_blog_posts'), 'http://blog.europeana.eu/', is_morelink: true)]
    end

    ##
    # Support method for menu_data, remove upon refactor.
    #
    def navigation_global_primary_nav_galleries
      {
          text: I18n.t('global.navigation.galleries'),
          is_current: false,
          url: collections_galleries_path,
          submenu: false
      }
    end


    ##
    # Support method for menu_data, remove upon refactor.
    #
    def link_item(text, url, options = {})
      { text: text, url: url, submenu: false }.merge(options)
    end

    ##
    # Support method for menu_data, remove upon refactor.
    #
    def europeana_collections_url
      ENV['EUROPEANA_COLLECTIONS_URL'] || 'http://www.europeana.eu/portal/'
    end

    ##
    # Support method for menu_data, remove upon refactor.
    #
    def collections_galleries_path
      europeana_collections_url + 'explore/galleries'
    end

    def menu_items
      return exhibitions.limit(6) if is_foyer
      chapters
    end

    def exhibitions
      Alchemy::Page.published.visible.where(depth: 2, language_code: @page.language_code).order("lft ASC").all
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
      ([@page] + alternatives).map do |page|
        { rel: 'alternate', hreflang: page.language_code, href: show_page_url(page.language_code, page.urlname), title: nil}
      end
    end

    def language_default_link
      [{ rel: 'alternate', hreflang: 'x-default', href: url_without_locale(url, locale: @page.language_code), title: nil }]
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
      "http://#{ENV.fetch('CDN_HOST', ENV.fetch('APP_HOST', 'localhost'))}#{ENV.fetch('APP_PORT', nil).nil? ? '' : ':'+ ENV.fetch('APP_PORT', nil)}#{path}"
    end

    private

      def prepend_portal_breadcrumb(crumbs)
        # Prepend the link to the portal.
        crumbs.unshift(
          url: europeana_collections_url,
          title: I18n.t('site.navigation.breadcrumb.return_home', default: 'Return to Home'),
          is_first: true
        )
        crumbs
      end
  end
end
