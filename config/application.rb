require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fedena
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.session_store(:cookie_store, {
      :key => '_fedena_session',
      :secret => '93bd9933128611446605e1d410d003a6643d59c4494a56e538f4bb154284c14f5a56c8ed9e7b1b38593e6f557b1f28d763f0b0093e12ff515dea1107d2e1306b'
    })

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'models', 'hr')
    config.autoload_paths << Rails.root.join('app', 'models', 'finance')
    config.filter_parameters += [:password]
  end
end
