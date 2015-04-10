Rails.application.configure do
  config.action_mailer.default_url_options = {:host => 'http://video-game-trivia.herokuapp.com' }
  Rails.application.routes.default_url_options[:host] = 'http://video-game-trivia.herokuapp.com/'
  config.serve_static_files = true

  config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'gmail.com',
      user_name:            'fakecapstone@gmail.com',
      password:             'capstone123',
      authentication:       'plain',
      enable_starttls_auto: true  }

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier

  config.assets.compile = true
  config.assets.compress = true
  config.assets.digest = true
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
end
