require 'faraday'

module Swrve
  class Configuration
    attr_accessor :ab_test_url, :api_url, :app_version, :api_key, :local_resource_path, :game_id, :debug_url,
                  :load_local_resources, :debug, :http_adapter, :api_version, :resource_timeout
    DEFAULT_API_ENDPOINT = 'api.swrve.com'
    DEFAULT_ABTEST_ENDPOINT = 'abtest.swrve.com'

    def initialize
      @app_version      = '0.0'
      @debug_url        = 'https://debug.api.swrve.com'
      @http_adapter     = Faraday.default_adapter
      @api_version      = 1
      @resource_timeout = 4
    end

    def build_endpoints
      return if @api_url && @ab_test_url
      @api_url, @ab_test_url = [ "https://#{game_id}.#{DEFAULT_API_ENDPOINT}", 
                                 "https://#{game_id}.#{DEFAULT_ABTEST_ENDPOINT}" ]
    end

    def validate!
      [:game_id, :api_key].each do |check_valid|
        raise ConfigurationError, "#{check_valid} is a required configuration setting" if self.send(check_valid).nil?
      end
      warn 'app_version is a highly recommended configuration setting, defaulting to 0.0' if app_version == '0.0'
    end
  end

  class ConfigurationError < Exception; end
end
