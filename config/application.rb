require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BadeblogApi
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    config.api_only = true

    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Cookies

    config.session_store :cookie_store, key: '_interslice_session'
  end
end
