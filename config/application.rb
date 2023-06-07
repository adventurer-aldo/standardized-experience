require_relative 'boot'

require 'rails/all'
require 'statistics'
require 'require_all'
require 'dotenv'
require_all './lib'

Dotenv.load

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_job.queue_adapter = :queue_classic
    config.active_record.schema_format = :sql
    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      authentication: 'plain',
      domain: 'gmail.com',
      user_name: ENV['MAIL_ADDRESS'],
      password: ENV['MAIL_PASSWORD'],
      enable_starttls_auto: true,
      open_timeout: 5,
      read_timeout: 5
    }

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
