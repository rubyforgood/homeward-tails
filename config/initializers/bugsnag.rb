if Rails.application.credentials.bugsnag_api_key.present?
  Bugsnag.configure do |config|
    config.api_key = Rails.application.credentials.bugsnag_api_key
  end
else
  Bugsnag.configuration.logger = ::Logger.new("/dev/null")
end
