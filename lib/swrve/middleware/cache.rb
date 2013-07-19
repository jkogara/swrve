require 'dalli'

module Swrve
  module Middleware
    class Cache

      attr_accessor :client

      def initialize
        @client = Swrve.config.cache_adapter.new do |cache_config|
          Swrve.config.cache.each do |k,v|
            cache_config.send(k, v)
          end
        end
      end

      # Looks for an existing swrve session or creates it, refreshes the cache each time it's called
      # Options:
      #   :start_session => false - don't do session_start after creating a session

      def find_or_create_session(uid, options = {start_session: true })
        session = cache(uid)
        return session[:session_token] if session[:session_token].present?

        session_token = calculate_session_token(uid)

        update_cache(uid, :session_token => session_token)
        session_start(session_token) unless options[:start_session] == false

        session_token
      end
    end
  end
end
