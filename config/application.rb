require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)

module TapyrusTokenMetadataSample
  class Application < Rails::Application
    config.load_defaults 7.0
    config.generators.template_engine = :slim
  end
end
