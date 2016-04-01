module MustacheHelper
  def head_links
    links = [
      # { rel: 'shortcut icon', type: 'image/x-icon', href: asset_path('favicon.ico') },
      { rel: 'stylesheet', href: styleguide_url('/css/virtual-exhibitions/screen.css'), media: 'all', css: 'true' },
      # { rel: 'stylesheet', href: styleguide_url('/css/screen.css'), media: 'all', css: 'true' },
      # { rel: 'stylesheet', href: styleguide_url('/css/screen.css'), media: 'all', css: 'true' },

      { rel: 'search', type: 'application/opensearchdescription+xml',
        href: Rails.application.config.x.europeana_opensearch_host + '/opensearch.xml',
        title: 'Europeana Search' }
    ]
    if params[:controller] == 'home' && params[:action] == 'index'
      links << { rel: 'canonical', href: root_url }
    end

    links = links + page_object.language_alternatives_tags
    links = links + page_object.language_default_link
    { items: links }
  end

  def js_vars
    page_name = (params[:controller] || '') + '/' + (params[:action] || '')
    [
      {
        name: 'pageName', value: page_name
      }
    ]
  end

  def js_files
    [{ path: styleguide_url('/js/dist/require.js'),
      data_main: styleguide_url('/js/dist/main/main-virtual-exhibitions') }]
  end

  def breakpoint_pixels
    {
      "img":{
        "show_thumbnail": "1px",
        "show_small": "200px",
        "show_half":  "400px",
        "show_full":  "800px"
      },
      "bg":{
        "show_thumbnail": "1px",
        "show_small": "200px",
        "show_half":  "400px",
        "show_full":  "800px"
      },
      "bg-hr":{
        "dpr": "2",
        "dpr_fraction": "2/1",
        "show_thumbnail": "1",
        "show_small": "400px",
        "show_half":  "800px",
        "show_full":  "1600px"
      }
    }
  end


  def mustache
    @mustache ||= {}
  end

  def head_meta
    mustache[:head_meta] ||= begin
      title = page_object.title
      description = page_object.description
      head_meta = [
        { meta_name: 'description', content: description },
        { meta_property: 'fb:app_id', content: '185778248173748' },
        { meta_name: 'twitter:card', content: 'summary' },
        { meta_name: 'twitter:site', content: '@EuropeanaEU' },
        { meta_property: 'og:site_name', content: 'Europeana Exhibitions' },
        { meta_property: 'og:description', content: description },
        { meta_property: 'og:url', content: page_object.url },
        { meta_property: 'og:title', content: title},
        { meta_property: 'og:image', content: page_object.thumbnail},
      ]
      head_meta << page_object.robots_tag
      head_meta + super
    end
  end


  def navigation
    mustache[:navigation] ||= begin
      {
        global: {
          options: {
            search_active: false,
            settings_active: true
          },
          logo: {
            url: root_path,
            text: 'Europeana ' + t('global.search-collections')
          },
          primary_nav: {
            menu_id: 'main-menu',
            items: page_object.menu_data
          },
          utility_nav: {
            menu_id: 'settings-menu',
            style_modifier: 'caret-right',
            tabindex: 6,
            items: [
              {
                url: '#',
                text: 'Languages',
                icon: 'settings',
                submenu: {
                  items: page_object.alternatives.collect do |alt|
                    {
                      text: alt.language.name,
                      url: show_page_url(urlname: alt.urlname, locale: alt.language_code)
                    }

                  end
                }
              }
            ]
          }
        },
        home_url: root_url,
        footer: {
          linklist1: {
            title: t('global.more-info'),
            # Use less elegant way to get footer links
            #
            # items: Page.primary.map do |page|
            #   {
            #     text: t(page.slug, scope: 'site.footer.menu'),
            #     url: static_page_path(page, format: 'html')
            #   }
            # end
            items: [
              {
                text: t('site.footer.menu.about'),
                url: 'https://europeana.eu/about'
              },
              {
                text: t('site.footer.menu.data-providers'),
                url: 'https://europeana.eu/about'
              },
              {
                text: t('site.footer.menu.become-a-provider'),
                url: 'http://pro.europeana.eu/share-your-data/'
              }
            ]
          },
          linklist2: {
            title: t('global.help'),
            items: [
              {
                text: t('site.footer.menu.search-tips'),
                url: 'https://europeana.eu/help'
              },
              # {
              #   text: t('site.footer.menu.using-myeuropeana'),
              #   url: '#'
              # },
              {
                text: t('global.terms-and-policies'),
                url: 'https://europeana.eu/rights'
              }
            ]
          },
          social: {
            url: page_object.url
            facebook: true,
            pinterest: true,
            twitter: true,
            googleplus: true,
            text: "Share this Exhibition"
          }
        }
      }
    end
  end
end
