Rails.application.configure do
  config.action_mailer.default_url_options = {:host => "localhost:3000"}
  Rails.application.routes.default_url_options[:host] = 'limitless-lowlands-6859.herokuapp.com'
  config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'gmail.com',
      user_name:            'fakecapstone@gmail.com',
      password:             'capstone123',
      authentication:       'plain',
      enable_starttls_auto: true
  }

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

  ActiveMerchant::Billing::Base.mode = :test
  paypal_options = {
      login: "fakecapstone-facilitator_api1.gmail.com",
      password: "92T3LU2GG9JD73KH",
      signature: "Acahxk2GWNxOEVJIHTRY7rZRzpXoAoOO2tgBUKAeEvBKsjzdb6ZRXpmz"
  }
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)

end
