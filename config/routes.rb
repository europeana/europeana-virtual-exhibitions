Rails.application.routes.draw do
  default_url_options :host => ENV.fetch('APP_HOST', 'http://test.npc.eanadev.org')
  scope '/portal/exhibitions' do
    mount Alchemy::Engine => '/'
  end


  get '/portal/exhibitions/sitemap-index.xml' => 'sitemap#index'
  get '/portal/:locale/exhibitions/sitemap.xml' => 'sitemap#show', constraints: { :locale => /[a-z]{2}/}, as: :sitemap, defaults: {format: :xml}
  get '/portal/exhibitions/robots.txt' => 'sitemap#robots'
  get '/portal/:locale/exhibitions/*urlname(.:format)' => 'alchemy/pages#show', as: :show_page, constraints: { :locale => /[a-z]{2}/}


end
