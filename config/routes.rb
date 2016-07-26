Rails.application.routes.draw do
  default_url_options(
    {
      host: ENV.fetch('APP_HOST', nil),
      port: ENV.fetch('APP_PORT', nil)
    }
  )

  root to: 'locale#index'

  scope '/:locale', constraints: { locale: /[a-z]{2}/ } do
    get '/', to: redirect('%{locale}/exhibitions/foyer')
    scope '/exhibitions' do
      get '/', to: redirect('%{locale}/exhibitions/foyer')
      get 'sitemap.xml', to: 'sitemap#show', as: :sitemap, defaults: { format: :xml }
      get '/feed.:format', to: 'sitemap#feed', constraints: { format: /(xml)/ }
      get '/*urlname(.:format)', to: 'alchemy/pages#show', as: :show_page
    end
  end

  scope '/exhibitions' do
    mount Alchemy::Engine => '/'

    namespace :alchemy, path: nil do
      namespace :api, defaults: { format: 'json' } do
        resources :exhibitions, only: [:index]
      end
    end

    get '/sitemap-index.xml', to: 'sitemap#index'
    get '/robots.txt', to: 'sitemap#robots'
  end

#   get '*path', to: 'locale#show'
end
