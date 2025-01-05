# frozen_string_literal: true

# name: gorisa-plugin-kakao
# about: gorisa plugin for Kakao login
# meta_topic_id:
# version: 0.0.1
# authors: archmagece
# url: https://gorisa.kr

enabled_site_setting :enable_login_with_kakao

gem "omniauth-kakao", "1.0.1"

register_svg_icon "fab-kakao"

require_relative "lib/auth/login_with_kakao_authenticator"
require_relative "lib/validators/enable_login_with_kakao_validator"
require_relative "lib/omniauth/strategies/kakao"

auth_provider authenticator: Auth::LoginWithKakaoAuthenticator.new, icon: "fab-kakao"
