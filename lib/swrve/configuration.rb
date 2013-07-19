require 'faraday'
require 'dalli'

module Swrve
  class Configuration
    attr_accessor :ab_test_url, :api_url, :web_app_version, :api_key, :local_resource_path, :game_id, :debug_url,
                  :load_local_resources, :debug, :http_adapter, :cache_adapter, :cache_config

    def initialize
      @ab_test_url = 'https://abtest.swrve.com'
      @api_url = 'https://api.swrve.com'
      @web_app_version = '1.0'
      @debug_url = 'https://debug.api.swrve.com'
      @http_adapter = Faraday.default_adapter
      @cache_adapter = Dalli::Client
      @cache_config = {}
    end
  end
end
