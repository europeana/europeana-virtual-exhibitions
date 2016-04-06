Rails.application.routes.draw do
  default_url_options({:host => ENV.fetch('APP_HOST', 'test.npc.eanadev.org'), :port => ENV.fetch('APP_PORT', nil)})
  scope '/portal/exhibitions' do
    mount Alchemy::Engine => '/'
  end

  scope '/portal/exhibitions' do
    namespace :alchemy, path: nil do
      namespace :api, defaults: {format: 'json'} do
        resources :exhibitions, only: [:index]
      end
    end
  end

  get '/portal/exhibitions/sitemap-index.xml' => 'sitemap#index'
  get '/portal/exhibitions/:locale/sitemap.xml' => 'sitemap#show', constraints: { :locale => /[a-z]{2}/}, as: :sitemap, defaults: {format: :xml}
  get '/portal/exhibitions/robots.txt' => 'sitemap#robots'
  get '/portal/:locale/exhibitions/*urlname(.:format)' => 'alchemy/pages#show', as: :show_page, constraints: { :locale => /[a-z]{2}/}

end
