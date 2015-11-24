Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, model: Staff, fields: [:email], path_prefix: '/api/v1/staff'
end
