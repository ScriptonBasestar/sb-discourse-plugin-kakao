# frozen_string_literal: true

require "jwt"
require "oauth2"
require "omniauth/strategies/oauth2"
require "uri"

module OmniAuth
  module Strategies
    class KakaoOauth2 < OmniAuth::Strategies::OAuth2
      ALLOWED_ISSUERS = ["kauth.kakao.com", "https://kauth.kakao.com"].freeze
      # BASE_SCOPE_URL = 'https://kauth.kakao.com/oauth/authorize/'
      BASE_SCOPES = %w[profile account_email openid].freeze
      DEFAULT_SCOPE = "account_email,profile"
      IMAGE_SIZE_REGEXP = /(s\d+(-c)?)|(w\d+-h\d+(-c)?)|(w\d+(-c)?)|(h\d+(-c)?)|c/
      AUTHORIZE_OPTIONS = %i[access_type hd login_hint prompt request_visible_actions scope state redirect_uri include_granted_scopes enable_granular_consent openid_realm device_id device_name]

      BASE_URL = "https://kauth.kakao.com"
      AUTHORIZE_URL = "/oauth/authorize"
      AUTHORIZE_TOKEN_URL = "/oauth/token"
      TOKEN_INFO_URL = "/oauth/tokeninfo"

      OPENID_CONFIG_URL = "https://kauth.kakao.com/.well-known/openid-configuration"

      # https://kapi.kakao.com/v2/user/me
      USER_INFO_URL = 'v1/oidc/userinfo'
# {10 items
# "sub":string"123456789"
# "name":string"홍길동"
# "nickname":string"홍길동"
# "picture":string"${IMAGE_PATH}"
# "email":string"sample@sample.com"
# "email_verified":booltrue
# "gender":string"MALE"
# "birthdate":string"2002-11-30"
# "phone_number":string"+82 00-0000-0000"
# "phone_number_verified":booltrue
# }
      # USER_INFO_URL = "/v2/user/me"
      # {
      #   "id": 123456789,
      #   "kakao_account": {
      #     "profile_needs_agreement": false,
      #     "profile": {
      #       "nickname": "홍길동",
      #       "thumbnail_image_url": "http://yyy.kakao.com/.../img_110x110.jpg",
      #       "profile_image_url": "http://yyy.kakao.com/dn/.../img_640x640.jpg",
      #       "is_default_image": false,
      #       "is_default_nickname": false
      #     },
      #     "email_needs_agreement": false,
      #     "is_email_valid": true,
      #     "is_email_verified": true,
      #     "email": "sample@sample.com",
      #     "name_needs_agreement": false,
      #     "name": "홍길동",
      #     "age_range_needs_agreement": false,
      #     "age_range": "20~29",
      #     "birthday_needs_agreement": false,
      #     "birthday": "1130",
      #     "gender_needs_agreement": false,
      #     "gender": "female"
      #   },
      #   "properties": {
      #     "nickname": "홍길동카톡",
      #     "thumbnail_image": "http://xxx.kakao.co.kr/.../aaa.jpg",
      #     "profile_image": "http://xxx.kakao.co.kr/.../bbb.jpg",
      #     "custom_field1": "23",
      #     "custom_field2": "여"
      #   }
      # }

      option :name, "kakao"
      option :client_options,
             site: BASE_URL,
             authorize_url: AUTHORIZE_URL,
             token_url: AUTHORIZE_TOKEN_URL

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

      def callback_url
        options.redirect_url || (full_host + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization "kakao", "Kakao"
