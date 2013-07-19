require 'yaml'
require 'forwardable'
require 'swrve/middleware/http'
require 'swrve/middleware/cache'

module Swrve
  module Api
    class Resources
      extend Forwardable

      def_instance_delegator :@resources_endpoint, :get

      def initialize
        @resources_endpoint = Middleware::Http.new(Swrve.config.ab_test_url)
      end

      def resources(uid, timestamp = nil)
        return local_resources if config.load_local_resources
        remote_resources(uid, timestamp)
      end

      private

      def remote_resources(uid, created_at = nil)

        options = {
          user:        uid,
          api_key:     config.api_key,
          app_version: config.web_app_version,
          joined:      (created_at || Time.now).to_i * 1000
        }

        request  = '/api/1/user_resources'
        response = remote_resources_endpoint.get(request, query: options, timeout: config.resource_timeout)

        if handle_response(response)
          resources = JSON.parse(response.body)
          update_cache(uid, resources: resources)
          resources
        else
          []
        end
      end

      def local_fixtures
        Dir[File.join(config.local_resource_path, '**/*.yaml')]
      end

      def local_resources
        local_fixtures.
          map { |f| YAML.load(File.read(f)) }.
          select { |test| test["enabled"] }.
          map { |test| test["variants"][test["selected"]] }
      end

      def config
        Swrve.config
      end
    end
  end
end

