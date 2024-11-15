Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['https://myideasmywords.up.railway.app'] || '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'],
      credentials: false
  end
end