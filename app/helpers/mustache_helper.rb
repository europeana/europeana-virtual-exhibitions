module MustacheHelper
  def css_files
    [
      { path: styleguide_url('/css/virtual-exhibitions/screen.css'), media: 'all' }
    ]
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
    [
      {
        path: styleguide_url('/js/modules/require.js'),
        data_main: styleguide_url('/js/modules/main/templates/main-virtual-exhibitions')
      }
    ]
  end

  def breakpoint_pixels
    {
      img: {
        show_thumbnail: '1px',
        show_small: '200px',
        show_half:  '400px',
        show_full:  '800px'
      },
      bg: {
        show_thumbnail: '1px',
        show_small: '200px',
        show_half:  '400px',
        show_full:  '800px'
      },
      bghr: {
        dpr: '2',
        dpr_fraction: '2/1',
        show_thumbnail: '1',
        show_small: '400px',
        show_half:  '800px',
        show_full:  '1600px'
      }
    }
  end

  def version
    { is_alpha: false }
  end

  def mustache
    @mustache ||= {}
  end

  def utility_nav
    return {} unless page_object.alternatives.present?
    {
      menu_id: 'settings-menu',
      style_modifier: 'caret-right',
      tabindex: 6,
      items: [
        {
          url: '#',
          text: t('site.settings.language.label'),
          icon_class: 'svg-icon-language',
          submenu: {
            items: page_object.alternatives.map do |alt|
              {
                text: alt.language.name,
                url: show_page_url(urlname: alt.urlname, locale: alt.language_code),
                submenu: false
              }
            end
          }
        }
      ]
    }
  end

  def head_meta
    mustache[:head_meta] ||= begin
      title = page_object.title
      description = page_object.description
      head_meta = [
        { meta_name: 'description', content: description },
        { meta_property: 'fb:app_id', content: '185778248173748' },
        { meta_property: 'og:site_name', content: 'Europeana Exhibitions' },
        { meta_property: 'og:description', content: description },
        { meta_property: 'og:url', content: page_object.url },
        { meta_property: 'og:title', content: title},
        { meta_property: 'og:image', content: page_object.thumbnail(:facebook) || false },
      ]
      head_meta << page_object.robots_tag
      twitter_card_meta + head_meta + super
    end
  end

  def page_config
    {
      newsletter: true
    }
  end

  def newsletter
    {
      form: {
        action: 'https://europeana.us3.list-manage.com/subscribe/post?u=ad318b7566f97eccc895e014e&amp;id=1d4f51a117',
        language_op: true
      }
    }
  end

  def twitter_card_meta
    meta = []

    meta << { meta_name: 'twitter:site', content: '@EuropeanaEU' }
    meta << { meta_name: 'twitter:title', content: page_object.title }
    meta << { meta_name: 'twitter:description', content: page_object.description }

    if page_object.thumbnail
      meta << { meta_name: 'twitter:card', content: 'summary_large_image' }
      meta << { meta_name: 'twitter:creator', content: '@EuropeanaEU' }
      meta << { meta_name: 'twitter:image', content: page_object.thumbnail(:twitter) }
    else
      meta << { meta_name: 'twitter:card', content: 'summary' }
    end
    meta
  end

  def footer
    page_object.is_foyer ? foyer_footer : page_footer
  end

  def foyer_footer
    {
      linklist1: {
        title: t('global.more-info'),
        items: [
          {
            text: t('site.footer.menu.about'),
            url: "#{europeana_collections_url}about.html"
          },
          {
            text: t('site.footer.menu.roadmap'),
            url: "#{europeana_collections_url}roadmap.html"
          },
          {
            text: t('site.footer.menu.data-providers'),
            url: "#{europeana_collections_url}explore/sources.html"
          },
          {
            text: t('site.footer.menu.become-a-provider'),
            url: 'http://pro.europeana.eu/share-your-data/'
          },
          {
            text: t('site.footer.menu.contact-us'),
            url: "#{europeana_collections_url}contact.html"
          }
        ]
      },
      linklist2: {
        title: t('global.help'),
        items: [
          {
            text: t('site.footer.menu.search-tips'),
            url: "#{europeana_collections_url}help"
          },
          {
            text: t('global.terms-and-policies'),
            url: "#{europeana_collections_url}rights"
          }
        ]
      },
      social: {
          facebook: true,
          pinterest: true,
          twitter: true,
          googleplus: true
      },
      subfooter: {
        items: [
          { text: 'Home', url: '' },
          { text: 'Terms of use & policies', url: "#{europeana_collections_url}rights/terms-and-policies.html" },
          { text: 'Contact us', url: '' },
          { text: 'Home', url: '' },

        ]
      }
    }
  end

  def page_footer
    {
      items: [
        { text: t('exhibitions.contacts', default: 'Contacts'), url: "#{europeana_collections_url}contact.html" },
        { text: t('site.footer.menu.about'), url: "#{europeana_collections_url}about.html" },
        { text: 'Europeana ' + t('global.search-collections'), url: "#{europeana_collections_url}" }
      ]
    }
  end

  def social
    {
      url: page_object.url,
      facebook: true,
      pinterest: true,
      twitter: true,
      googleplus: true,
      text: 'Share this Exhibition'
    }
  end

  def growl_message
    t('exhibitions.scroll-down')
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
            url: europeana_collections_url,
            text: 'Europeana ' + t('global.search-collections')
          },
          primary_nav: {
            menu_id: 'main-menu',
            items: page_object.menu_data
          },
          utility_nav: utility_nav
        },
        home_url: root_url,
        footer: footer
      }
    end
  end

  private

  def europeana_collections_url
    ENV['EUROPEANA_COLLECTIONS_URL'] || 'http://www.europeana.eu/portal/'
  end
end
