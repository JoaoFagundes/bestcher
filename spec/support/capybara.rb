Capybara.configure do |config|
  config.default_max_wait_time = 5
  config.automatic_reload = true
  config.always_include_port = true

  # test_env_number = ENV.fetch("TEST_ENV_NUMBER") { 1 }.to_i
  # port_number = ENV.fetch("PORT") { 4000 }.to_i + test_env_number
  port_number = 4000

  config.app_host = "http://#{Rails.application.credentials.dig(:APPLICATION_HOST)}:#{port_number}"
  config.server_host = '127.0.0.1'
  config.server_port = port_number.to_s
end
