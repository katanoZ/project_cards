require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjectCatdsTasks
  class Application < Rails::Application
    config.load_defaults 5.2

    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end

    config.rack_dev_mark.enable = !Rails.env.production?
  end
end
