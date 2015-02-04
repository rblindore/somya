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
    config.i18n.default_locale = :en

    # config.autoload_paths << Rails.root.join('lib')
    # ['in_place_edit'].each do |name|
    #   config.autoload_paths << Rails.root.join('lib', name)
    # end
    config.autoload_paths += Dir["#{Rails.root}/lib/**/"]
    config.autoload_paths << Rails.root.join('app', 'models', 'hr')
    config.autoload_paths << Rails.root.join('app', 'models', 'finance')
    config.autoload_paths << Rails.root.join('app', 'models', 'student.rb')

    # Line added to fix circular dependency error while loading student
    config.middleware.delete Rack::Lock
    config.reload_classes_only_on_change = true
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.test_framework :rspec
      g.integration_tool :rspec
    end
  end
end
