Koala.configure do |config|
  config.app_id = Rails.application.credentials.dig(:facebook_id)
  config.app_secret = Rails.application.credentials.dig(:facebook_secret)
  config.access_token = -> { User.find_by(id: current_user_id)&.access_token }
  config.app_access_token  = Rails.application.credentials.dig(:app_access_token)
end