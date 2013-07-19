require 'forwardable'
require 'swrve/version'
require 'swrve/configuration'
require 'swrve/middleware/http'
require 'swrve/api/events'
require 'swrve/api/resources'
require 'swrve/middleware/cache'

module Swrve
  class << self
    extend Forwardable
    
    attr_accessor :config, :event_sender, :resource_getter, :cache
    
    def_delegators :@resource_getter, :resources, :resource_diff, :resource
    def_delegators :@cache, :find_or_create_session, :update_session
    def_delegators :@event_sender,  :session_start, :session_end, :custom_event, :purchase, :buy_in, 
                                           :currency_given, :update_user 

    def configure
      @event_sender    = Swrve::Api::Events.new
      @resource_getter = Swrve::Api::Resources.new
      @cache           = Swrve::Middleware::Cache.new
      yield(config) if block_given?
    end

    def config
      @config ||= Configuration.new
    end
  end
end
