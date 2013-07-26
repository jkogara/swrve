require 'json'
require 'swrve/middleware/http'

module Swrve
  module Api
    class Events
      extend Forwardable

      attr_accessor :api_endpoint

      def_instance_delegator :@api_endpoint, :post

      def initialize
        @api_endpoint    = Swrve::Middleware::Http.new(Swrve.config.api_url + "/#{Swrve.config.api_version}")
        @web_app_version = Swrve.config.web_app_version
        @api_key         = Swrve.config.api_key
      end

      # Starts the user game session
      #  @param [String, #uuid] uuid Unique identifier for the user starting the session
      #  @return [String, swrve_payload (Hash) (defaults to: {}) — A customizable payload associated with the session_start event
      def session_start(uuid, swrve_payload = {})
        response = post('session_start', query_options(uuid, swrve_payload: fill_nil_values(swrve_payload)))
        handle_response(response)
      end

      def session_end(uuid, swrve_payload = {})
        post('session_end', query_options(uuid, swrve_payload: fill_nil_values(swrve_payload)))
      end

      def update_user(uuid, user_attributes = {})
        params = { user_initiated: (user_attributes.delete(:user_initiated) || true) }
        params.merge!(swrve_payload: fill_nil_values(user_attributes.delete(:swrve_payload) || {}))
  
        response = post('user', query_options(uuid, user_attributes.merge(params)))
        handle_response(response)
      end

      def purchase(uuid, item_id, cost, options = {})
        options = { item: item_id.to_s, cost: cost.to_f, currency: "USD", quantity: 1}.merge(options)
        
        response = post('purchase', query_options(uuid, options)) 
        handle_response(response)
      end

      def buy_in(uuid, amount, real_currency_name, reward_amount, reward_currency, options = {})
        payment_provider = options.delete( :payment_provider ) || "Default Payment Provider"
        swrve_payload = fill_nil_values(options[:swrve_payload] || {})

        response = post('buy_in', query_options(uuid, {cost: amount.to_f, local_currency: real_currency_name,
                                            reward_amount: reward_amount.to_f, reward_currency: reward_currency,
                                            payment_provider: payment_provider, swrve_payload: swrve_payload}))
        handle_response(response)
      end

      def currency_given(uuid, given_amount, given_currency, payload={})
        validate_amount(given_amount, given_currency)
        payload = fill_nil_values(payload)
        
        response = post('currency_given', query_options(uuid, { given_currency: given_currency, 
                                                     given_amount: given_amount,
                                                     swrve_payload: payload }))
        handle_response(response)
      end

      def create_event(uuid, name, payload = {})
        params = query_options(uuid, name: name, swrve_payload: fill_nil_values(payload))

        response = post('event', params)
        handle_response(response)
      end

      private

      def handle_response(response)
        if response.status < 400
          return 'OK'
        else
          raise Exception, "Error in request to Swrve: status => #{response.status}, info => #{response.body}"
        end
      end

      def validate_amount(amount, currency_name)
        raise Exception, "Invalid currency name #{currency_name}" if currency_name.empty?
        raise Exception, "Cannot give a zero amount #{amount.to_f}"    if amount.to_f == (0)
        raise Exception, "A negative amount is invalid #{amount.to_f}" if amount.to_f < (0)
      end

      def query_options(uuid, payload = {})
        { api_key: @api_key, app_version: @web_app_version, user: uuid }.merge(payload) 
      end

      #The swrve api does not accept nul JSON values
      def fill_nil_values(hash = {})
        ( hash.each { |k, v| hash[k] = '' if v.nil? } ).to_json
      end
    end
  end
end

