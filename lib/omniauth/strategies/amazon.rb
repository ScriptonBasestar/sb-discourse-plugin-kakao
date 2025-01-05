# frozen_string_literal: true

# This patch was merged into upstream (in 2019) but a new gem hasn’t been
# released yet.
module DiscourseLoginWithKakao
  module OmniAuthStrategyExtension
    extend ActiveSupport::Concern

    def callback_url
      origin = ENV["REDIRECT_URL_ORIGIN"] || full_host
      origin + script_name + callback_path
    end
  end
end
OmniAuth::Strategies::Kakao.prepend(DiscourseLoginWithKakao::OmniAuthStrategyExtension)
