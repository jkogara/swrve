require 'faraday'
require 'faraday_middleware'

module Swrve
  module Middleware
    class Http

      extend Forwardable

      attr_accessor :client

      def_instance_delegators :@client, :get, :post, :put

      def initialize(endpoint)
        @client = Faraday.new(endpoint) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Swrve.config.http_adapter
          faraday.response :raise_error
          faraday.use FaradayMiddleware::ParseJson
        end
      end
    end
  end
end
