OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
           ENV.fetch('FACEBOOK_APP_ID'),
           ENV.fetch('FACEBOOK_SECRET'),
           scope: 'email', info_fields: 'name,email,gender'
end
