require 'yaml'
require 'ostruct'
require 'forwardable'
require 'JSON'
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
        convert_to_bools(resources(uuid, timestamp).detect{ |exists| exists.uid == test_name } || OpenStruct.new({}))
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

        params = {
          user:        uuid,
          api_key:     Swrve.config.api_key,
          app_version: Swrve.config.web_app_version,
          joined:      (created_at || Time.now).to_i * 1000
        }

        request  = full_resource ? 'user_resources' : 'user_resources_diff'
        response = get(request, params)

        if response.status < 400
          response.body.map{|resource| OpenStruct.new(resource)}
        else
          []
        end
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

