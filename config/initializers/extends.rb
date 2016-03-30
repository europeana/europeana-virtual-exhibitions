Alchemy::Engine.routes.default_url_options[:host] = ENV.fetch('APP_HOST', 'test.npc.eanadev.org')
Alchemy::Engine.routes.default_url_options[:port] = ENV.fetch('APP_PORT', nil)