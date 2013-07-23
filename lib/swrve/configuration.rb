require 'faraday'

module Swrve
  class Configuration
    attr_accessor :ab_test_url, :api_url, :web_app_version, :api_key, :local_resource_path, :game_id, :debug_url,
                  :load_local_resources, :debug, :http_adapter, :api_version, :resource_timeout

    def initialize
      @ab_test_url = 'https://abtest.swrve.com'
      @api_url = 'https://api.swrve.com'
      @web_app_version = '1.0'
      @debug_url = 'https://debug.api.swrve.com'
      @http_adapter = Faraday.default_adapter
      @api_version  = 1
      @resource_timeout = 4
    end
  end
end
