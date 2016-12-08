require_relative 'boot'
# require_relative '../app/models/anagrammer'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AnagramServer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.blurb = "Loading dictionary..."
    # config.anagrammer = Anagrammer.new
  end
end
