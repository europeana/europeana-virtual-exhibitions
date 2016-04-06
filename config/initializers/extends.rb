Alchemy::Engine.routes.default_url_options[:host] = ENV.fetch('APP_HOST', 'test.npc.eanadev.org')
Alchemy::Engine.routes.default_url_options[:port] = ENV.fetch('APP_PORT', nil)

Alchemy.login_path = '/portal/exhibitions/admin/login'
Alchemy.logout_path = '/portal/exhibitions/admin/logout'
Alchemy.signup_path = '/portal/exhibitions/admin/signup'
