# frozen_string_literal: true

# app/controllers/concerns/secured.rb
module Secured
    extend ActiveSupport::Concern
  
    # エラーレスポンスのメッセージの定義
    REQUIRES_AUTHENTICATION = { message: 'Requires authentication' }.freeze
    BAD_CREDENTIALS = {
      message: 'Bad credentials'
    }.freeze

    MALFORMED_AUTHORIZATION_HEADER = {
      error: 'invalid_request',
      error_description: 'Authorization header value must follow this format: Bearer access-token',
      message: 'Bad credentials'
    }.freeze

    INSUFFICIENT_PERMISSIONS = {
      error: 'insufficient_permissions',
      error_description: 'The access token does not contain the required permissions',
      message: 'Permission denied'
    }.freeze
  
    def authorize
      token = token_from_request
  
      return if performed?

      validation_response = Auth0Client.validate_token(token)
  
      @decoded_token = validation_response.decoded_token
  
      return unless (error = validation_response.error)
  
      # access_tokenの検証結果がNGだった場合はエラーを返す
      render json: { message: error.message }, status: error.status
    end
  
    def validate_permissions(permissions)
      raise 'validate_permissions needs to be called with a block' unless block_given?
      return yield if @decoded_token.validate_permissions(permissions)
  
      render json: INSUFFICIENT_PERMISSIONS, status: :forbidden
    end
  
    private
  

    # リクエストヘッダーのAuthorization値を取得
    def token_from_request
      authorization_header_elements = request.headers['Authorization']&.split
  
      # もしリクエストヘッダーにAuthorizationがない場合はエラーレスポンスを返す
      render json: REQUIRES_AUTHENTICATION, status: :unauthorized and return unless authorization_header_elements
  
      # もしリクエストヘッダーにAuthorizationの値の要素が2でなければ、エラーを返す
      # 想定しているAuthorizationの値の形式はBearer access-tokenの2つの要素のため
      unless authorization_header_elements.length == 2
        render json: MALFORMED_AUTHORIZATION_HEADER,
               status: :unauthorized and return
      end
  
      scheme, token = authorization_header_elements
  
      # もしリクエストヘッダーにAuthorizationの値の最初の要素の値がBearerでなければエラーを返す
      render json: BAD_CREDENTIALS, status: :unauthorized and return unless scheme.downcase == 'bearer'
  
      token
    end
  end