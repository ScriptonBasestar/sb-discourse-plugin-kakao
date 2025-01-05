# frozen_string_literal: true

# name: discourse-login-with-kakao
# about: Enables login authentication via Login with Kakao
# meta_topic_id: 117564
# version: 0.0.1
# authors: Alan Tan
# url: https://github.com/discourse/discourse-login-with-kakao

enabled_site_setting :enable_login_with_kakao

gem "omniauth-kakao", "1.0.1"

register_svg_icon "fab-kakao"

require_relative "lib/auth/login_with_kakao_authenticator"
require_relative "lib/validators/enable_login_with_kakao_validator"
require_relative "lib/omniauth/strategies/kakao"

auth_provider authenticator: Auth::LoginWithKakaoAuthenticator.new, icon: "fab-kakao"
