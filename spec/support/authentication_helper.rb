require 'jwt'
require 'securerandom'

module AuthenticationHelper
  def auth_headers(user)
    return {} unless user

    token = get_jwt_token(user)
    { 'Authorization' => "Bearer #{token}" }
  end

  private

  def get_jwt_token(user)
    @_jwt_tokens ||= {}
    return @_jwt_tokens[user.id] if @_jwt_tokens[user.id]

    now = Time.now.to_i
    payload = {
      sub: user.id.to_s,
      scp: 'user',
      iat: now,
      exp: now + 24.hours.to_i,
      jti: SecureRandom.uuid
    }
    
    user.on_jwt_dispatch(payload, nil) if user.respond_to?(:on_jwt_dispatch)
    
    secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") do
      Rails.application.credentials.devise_jwt_secret_key || 
      Rails.application.secret_key_base
    end
    
    token = JWT.encode(payload, secret, 'HS256')
    @_jwt_tokens[user.id] = token
    token
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :request
  
  config.before(:each) do
    @_jwt_tokens = nil
  end
end
