Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, fields: [:email], path_prefix: '/api/v1/staff/auth'
end
