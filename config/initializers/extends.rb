# frozen_string_literal: true

Alchemy::Engine.routes.default_url_options = Rails.application.routes.default_url_options

Alchemy.login_path = Rails.application.config.relative_url_root + '/exhibitions/admin/login'
Alchemy.logout_path = Rails.application.config.relative_url_root + '/exhibitions/admin/logout'
Alchemy.signup_path = Rails.application.config.relative_url_root + '/exhibitions/admin/signup'
