require 'forwardable'
require 'swrve/version'
require 'swrve/configuration'
require 'swrve/middleware/http'
require 'swrve/api/events'
require 'swrve/api/resources'

module Swrve
  class << self
    extend Forwardable

    attr_accessor :config, :event_sender, :resource_getter

    def_delegators :@resource_getter, :resources, :resources_diff, :resource
    def_delegators :@event_sender, :session_start, :session_end, :create_event, :purchase, :buy_in, :currency_given, :update_user 

    def configure
      yield(config) if block_given?
      @event_sender    = Swrve::Api::Events.new
      @resource_getter = Swrve::Api::Resources.new
    end

    def config
      @config ||= Configuration.new
    end
  end
end
