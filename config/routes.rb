Rails.application.routes.draw do
  default_url_options(
    {
      host: ENV.fetch('APP_HOST', 'test.npc.eanadev.org'),
      port: ENV.fetch('APP_PORT', nil)
    }
  )

  scope '/exhibitions' do
    mount Alchemy::Engine => '/'
  end

  scope '/exhibitions' do
    namespace :alchemy, path: nil do
      namespace :api, defaults: {format: 'json'} do
        resources :exhibitions, only: [:index]
      end
    end
  end

  get '/exhibitions/sitemap-index.xml' => 'sitemap#index'
  get '/:locale/exhibitions/sitemap.xml' => 'sitemap#show',
    constraints: { locale: /[a-z]{2}/}, as: :sitemap, defaults: { format: :xml }
  get '/exhibitions/robots.txt' => 'sitemap#robots'
  get '/:locale/exhibitions/feed.:format' => 'sitemap#feed', constraints: { format: /(xml)/ }

  get '/:locale/exhibitions/*urlname(.:format)' => 'alchemy/pages#show',
    as: :show_page, constraints: { locale: /[a-z]{2}/ }
end
