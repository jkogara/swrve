require 'faraday'

module Swrve
  class Configuration
    attr_accessor :web_app_version, :api_key, :local_resource_path, :game_id,
                  :load_local_resources, :http_adapter, :api_version, :resource_timeout

    def initialize
      @web_app_version = '1.0'
      @http_adapter = Faraday.default_adapter
      @api_version  = 1
      @resource_timeout = 4
    end

    def ab_test_url
      raise 'Must specify game_id for Swrve Configuration' if game_id.nil?
      @ab_test_url || "https://#{game_id}.abtest.swrve.com"
    end
    def ab_test_url=(url)
      @ab_test_url = url
    end

    def api_url
      raise 'Must specify game_id for Swrve Configuration' if game_id.nil?
      @api_url || "https://#{game_id}.api.swrve.com"
    end
    def api_url=(url)
      @api_url = url
    end
  end
end
