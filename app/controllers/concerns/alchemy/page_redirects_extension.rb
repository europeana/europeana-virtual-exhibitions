# frozen_string_literal: true

module Alchemy
  PageRedirects.module_exec do
    # Returns an URL to redirect the request to.
    #
    # == Lookup:
    #
    # 0. THIS LOGIC IS A EUROPEANA SPECIFIC EXTENSION
    #    If the page is an unpublished 'foyer'/language_root we redirect to the language_root of the default language
    #    + If the default language 'foyer' isn't published we redirect to any published language_root of any language.
    #
    # 1. If the page is not published and we have a published child,
    #    we return the url top that page. (Configurable through +redirect_to_public_child+).
    # 2. If the page layout of the page found has a controller and action configured,
    #    we return the url to that route. (Configure controller and action in `page_layouts.yml`).
    # 3. If the current page URL has no locale prefixed, but we should have one,
    #    we return the prefixed URL.
    # 4. If no redirection is needed returns nil.
    #
    # @return String
    # @return NilClass
    #
    def redirect_url
      # This method is being overridden to ensure alternative languages take precedence
      # when trying to find a redirect for unpublished pages
      @_redirect_url ||= redirect_to_alternative_language_root_url || public_child_redirect_url ||
                         controller_and_action_url || locale_prefixed_url || nil
    end

    private

    def redirect_to_alternative_language_root_url
      return if @page.public? || !@page.language_root?

      page_to_redirect_to = default_language_public_language_root || any_public_language_root

      return unless page_to_redirect_to

      options = {
        locale: prefix_locale? ? page_to_redirect_to.language_code : nil,
        urlname: page_to_redirect_to.urlname
      }
      alchemy.show_page_path additional_params.merge(options)
    end

    # Returns the default language language_root page, if it's published
    #
    # Otherwise it returns nil.
    #
    def default_language_public_language_root
      Language.default.pages.find_by(language_root: true, public: true)
    end

    # Returns the language_root page for the first language it will find, where the foyer page is public.
    #
    # Otherwise it returns nil.
    #
    def any_public_language_root
      Page.find_by(language_root: true, public: true)
    end
  end
end
