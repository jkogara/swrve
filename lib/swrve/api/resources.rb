require 'yaml'
require 'forwardable'
require 'json'
require 'swrve/middleware/http'

module Swrve
  module Api
    class Resources
      extend Forwardable

      def_delegators :@resources_endpoint, :get

      def initialize
        @resources_endpoint = Middleware::Http.new(Swrve.config.ab_test_url + "/api/#{Swrve.config.api_version}")
      end

      def resource(uuid, test_name, timestamp = nil)
        convert_to_bools(resources(uuid, timestamp).detect{ |exists| exists['uid'] == test_name } || {})
      end

      def resources(uuid, timestamp = nil)
        return local_resources if Swrve.config.load_local_resources
        remote_resources(uuid, true, timestamp)
      end

      def resources_diff(uuid, timestamp = nil)
        return local_resources if Swrve.config.load_local_resources
        remote_resources(uuid, false, timestamp)
      end

      private

      def convert_to_bools(resource)
        resource.each do |k,v|
          resource[k] = true if v == 'true'
          resource[k] = false if v == 'false'
        end
        resource
      end

      def remote_resources(uuid, full_resource, created_at = nil)
        request  = full_resource ? 'user_resources' : 'user_resources_diff'
        response = get(request, build_params(uuid, created_at))

        response.status < 400 ? response.body : []
      end

      def build_params(uuid, created_at)
        {
          user:        uuid,
          api_key:     Swrve.config.api_key,
          app_version: Swrve.config.web_app_version,
          joined:      (created_at || Time.now).to_i * 1000
        }
      end

      def local_fixtures
        Dir[File.join(Swrve.config.local_resource_path, '**/*.yaml')]
      end

      def local_resources
        local_fixtures.
          map { |f| YAML.load(File.read(f)) }.
          select { |test| test["enabled"] }.
          map { |test| test["variants"][test["selected"]] }
      end
    end
  end
end

