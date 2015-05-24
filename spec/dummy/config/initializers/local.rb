I18n.enforce_available_locales = false
I18n.default_locale = 'zh-CN' if Rails.env.production? || Rails.env.development?
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]