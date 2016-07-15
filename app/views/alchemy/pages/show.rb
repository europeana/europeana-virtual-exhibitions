module Alchemy::Pages
  class Show < Alchemy::Base
    include MustacheHelper
    include Rails.application.routes.url_helpers

    def cached_body
      lambda do |text|
        Rails.cache.fetch(body_cache_key, expires_in: 24.hours) do
          Rails.logger.info "Missed cache for #{body_cache_key}"
          render(text)
        end
      end
    end


    def page_data
      {
        elements: page_object.elements,
        title: @page.title,
        url: show_page_url(locale, @page.urlname),
        next_page: next_page,
        previous_page: previous_page,
        chapter_elements: page_object.chapter_elements,
        credit_elements: page_object.credit_elements,
        is_chapter: page_object.is_chapter,
        is_foyer: page_object.is_foyer,
        is_exhibition: page_object.is_exhibition,
        is_credit: page_object.is_credit
      }
    end

    def json
      JSON.pretty_generate({
        js_files: js_files,
        head_links: head_links,
        breakpoint_pixels: breakpoint_pixels,
        css_files: css_files,
        page_data: page_data,
        breadcrumbs: breadcrumbs,
        share_links: share_links,
        next_page: next_page,
        previous_page: previous_page,
        head_meta: head_meta,
        navigation: navigation,
        footer: footer,
        google_analytics_code: google_analytics_code,
        growl_message: growl_message,
        title: title
      })
    end

    def is_foyer
      page_object.is_foyer
    end

    def is_credit
      page_object.is_credit
    end

    def is_chapter
      page_object.is_chapter
    end

    def is_exhibition
      page_object.is_exhibition
    end

    def title
      @page.title
    end

    def page_title
      @page.title
    end

    def share_links
      [:facebook, :twitter, :pinterest, :instagram].each.collect do |network|
        [network, show_page_url(locale, @page.urlname, {utm_source: network, utm_medium: :social, utm_campaign: exhibition.slug })]
      end.to_h
    end

    def editor_attribute(attribute)
      " contenteditable='true' data-content-id=1 data-content-type='text' "
    end

    def next_page
      return false unless is_chapter || is_credit || is_exhibition
      return format_page(@page.children.first) if is_exhibition
      format_page(@page.right_sibling)
    end

    def previous_page
      return false unless is_chapter || is_credit
      format_page(@page.left_sibling) || format_page(exhibition)
    end

    def format_page(page)
      return false if !page.present? || page.public == false
      {
        title: page.title,
        url: show_page_url(page.language.language_code, page.urlname)
      }
    end


    def url
      show_page_url(locale, @page.urlname)
    end

    def label
      "LABEL"
    end
    def breadcrumbs
      crumbs = @page.self_and_ancestors.where('depth >= 1').map do | ancestor |
        {
          url: show_page_url(locale, ancestor.urlname),
          title: ancestor.title
        }
      end

      # Prepend the link to the portal.
      crumbs.unshift(
                      url: europeana_collections_url,
                      title: t('site.navigation.breadcrumb.return_home', default: 'Return to Home'),
                      is_first: true
                    )

      # Set the index page's breadcrumb title to locale specific string.
      crumbs[1][:title] = t('site.navigation.breadcrumb.exhibitions.return_home', default: 'Exhibitions')

      crumbs.last[:is_last] = true
      crumbs
    end

    def exhibition
      @exhibition ||= (@page.depth == 1 ? @page : @page.self_and_ancestors.where(depth: 2).first)
    end

    def debug_mode
      params.include?(:debug)
    end

    def google_analytics_code
      ENV.fetch("GOOGLE_ANALYTICS_CODE", "UA-123456-1")
    end


    private
    def locale
      @locale ||= @page.language.language_code
    end

    def body_cache_key
      @page.cache_key
    end
  end
end
