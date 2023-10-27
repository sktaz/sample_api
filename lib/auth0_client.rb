# app/lib/auth0_client.rb

# frozen_string_literal: true

require 'jwt'
require 'net/http'

class Auth0Client 

  # Auth0 Client Objects 
  Error = Struct.new(:message, :status)
  Response = Struct.new(:decoded_token, :error)

  # Helper Functions 
  def self.domain_url
    # Auth0のドメイン
    ENV.fetch("AUTH0_DOMAIN", nil)
  end

  # access_tokenのデコード
  ## JWT.decodeメソッドの中身は下記を参照
  ## https://github.com/jwt/ruby-jwt/blob/main/lib/jwt/decode.rb
  def self.decode_token(token, jwks_hash)

    JWT.decode(token, nil, true, {
                 algorithm: 'RS256',
                 iss: domain_url,
                 verify_iss: true,
                 aud: ENV.fetch("AUTH0_AUDIENCE", nil),
                 verify_aud: true,
                 jwks: { keys: jwks_hash[:keys] }
               })
  end

  # 公開鍵を取得
  def self.get_jwks
    jwks_uri = URI("#{domain_url}.well-known/jwks.json")
    Net::HTTP.get_response jwks_uri
  end

  # access_tokenの正当性を検証 
  def self.validate_token(token)
    jwks_response = get_jwks

    unless jwks_response.is_a? Net::HTTPSuccess
      error = Error.new(message: 'Unable to verify credentials', status: :internal_server_error)
      return Response.new(nil, error)
    end

    jwks_hash = JSON.parse(jwks_response.body).deep_symbolize_keys

    # access_tokenの署名を検証とデコード処理
    decoded_token = decode_token(token, jwks_hash)

    Response.new(decoded_token, nil)

    # 今回は理解促進のためライブラリruby-jwtのエラーをそのまま返す
  rescue JWT::VerificationError, JWT::DecodeError => e
    error = Error.new(e.message, :unauthorized)
    Response.new(nil, error)
  end
end