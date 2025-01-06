# frozen_string_literal: true

require "jwt"
require "oauth2"
require "omniauth/strategies/oauth2"
require "uri"

module OmniAuth
  module Strategies
    class Kakao < OmniAuth::Strategies::OAuth2
      # ALLOWED_ISSUERS = ["kauth.kakao.com", "https://kauth.kakao.com"].freeze
      # BASE_SCOPE_URL = 'https://kauth.kakao.com/oauth/authorize/'
      # BASE_SCOPES = %w[profile account_email openid].freeze
      # DEFAULT_SCOPE = "account_email,profile"
      # IMAGE_SIZE_REGEXP = /(s\d+(-c)?)|(w\d+-h\d+(-c)?)|(w\d+(-c)?)|(h\d+(-c)?)|c/
      # AUTHORIZE_OPTIONS = %i[access_type hd login_hint prompt request_visible_actions scope state redirect_uri include_granted_scopes enable_granular_consent openid_realm device_id device_name]

      BASE_URL = "https://kauth.kakao.com"

      AUTHORIZE_URL = "/oauth/authorize"
      TOKEN_URL = "/oauth/token"
      TOKEN_INFO_URL = "/oauth/tokeninfo"
      # https://kapi.kakao.com/v2/user/me
      USER_INFO_URL = '/v1/oidc/userinfo'
      OPENID_CONFIG_URL = "/.well-known/openid-configuration"

      option :name, "kakao"
      option :client_options,
             site: BASE_URL,
             authorize_url: AUTHORIZE_URL,
             token_url: TOKEN_URL

      option :authorize_options, [:scope]

      uid { raw_info["sub"].to_s }

      info do
        {
          name: raw_info["name"],
          # username: raw_info["username"],
          nickname: raw_info["nickname"],
          image: raw_info["picture"],
          email: raw_info["email"],
          email_verified: raw_info["email_verified"],
          gender: raw_info["gender"],
          birthday: raw_info["birthday"],
          phone_number: raw_info["phone_number"],
          phone_number_verified: raw_info["phone_number_verified"],
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get(USER_INFO_URL).parsed
      end

      # dev
      # def callback_url
      #   # full_host = 'http://127.0.0.1:4200'
      #   full_host = 'http://localhost:4200'
      #   full_host + script_name + callback_path
      # end
      def callback_url
        full_host = 'http://localhost:4200'
      #   full_host + script_name + callback_path
        options.redirect_url || (full_host + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization "kakao", "Kakao"
