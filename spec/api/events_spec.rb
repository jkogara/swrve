require 'spec_helper'
require 'swrve/middleware/http'
module Swrve
  module Api
    describe Events do

      subject { Events.new }

      let(:http_middleware) { mock('http_middleware') }
      let(:config) { stub_everything('config', web_app_version: '1', api_version: 1, api_key: 'KEY', api_url: 'http://api_url') }

      before do
        Swrve.stubs(config: config)
      end

      describe '.new' do
        it 'sets up the endpoint with the correct url' do
          Swrve::Middleware::Http.expects(:new).with(config.api_url + "/#{config.api_version}")
  
          subject
        end

        before { Swrve::Middleware::Http.stubs(new: http_middleware) }

        it 'sets the correct app_version' do
          config.expects(:web_app_version)
          
          subject
        end

        it 'sets the correct api_key' do
          config.expects(:api_key)

          subject
        end
      end

      context 'Instance methods' do
        before do
          Swrve::Middleware::Http.stubs(new: http_middleware) 
          subject.stubs(query_options: {})
        end        

        describe '#session_start' do
          it 'posts to the session_start endpoint' do
            http_middleware.expects(:post).with('session_start', {})
            subject.session_start('UUID')
          end

          before { http_middleware.stubs(:post) }

          it 'prepares the query_options' do
            subject.expects(:query_options).with('UUID', swrve_payload: {}.to_json)

            subject.session_start('UUID')
          end

          it 'fills nil values on the swrve_payload' do
            subject.expects(:fill_nil_values).with({name: nil})

            subject.session_start('UUID', name: nil)
          end
        end

        describe '#session_end' do
          it 'posts to the session_end endpoint' do
            http_middleware.expects(:post).with('session_end', {})
            subject.session_end('UUID')
          end

          before { http_middleware.stubs(:post) }

          it 'prepares the query_options' do
            subject.expects(:query_options).with('UUID', swrve_payload: {}.to_json)

            subject.session_end('UUID')
          end

          it 'fills nil values on the swrve_payload' do
            subject.expects(:fill_nil_values).with({name: nil})

            subject.session_end('UUID', name: nil)
          end
        end

        describe '#update_user' do
          it 'posts to the user endpoint' do
            http_middleware.expects(:post).with('user', {})

            subject.update_user('UUID')
          end

          before { http_middleware.stubs(:post) }

          it 'defaults user_initiated to being true' do
            subject.expects(:query_options).with('UUID', user_initiated: true, swrve_payload: {}.to_json)

            subject.update_user('UUID')
          end

          it 'fills nil values on the swrve_payload' do
            subject.expects(:fill_nil_values).with({name: nil})

            subject.update_user('UUID', swrve_payload:{  name: nil })
          end
        end

        describe '#purchase' do
          it 'posts to the purchase endpoint' do
            http_middleware.expects(:post).with('purchase', {})

            subject.purchase('UUID', 1, 1)
          end

          before { http_middleware.stubs(:post) }

          it 'defaults currency and quantity to the correct values' do
            subject.expects(:query_options).with('UUID', item: 1.to_s, cost: 1.to_f, currency: 'USD', quantity: 1)

            subject.purchase('UUID', 1, 1)
          end

          it 'accepts currency and quantity values in the options' do
            subject.expects(:query_options).with('UUID', item: 1.to_s, cost: 1.to_f, currency: 'EURO', quantity: 10)

            subject.purchase('UUID', 1, 1, currency: 'EURO', quantity: 10)
          end
        end

        describe '#buy_in' do
          it 'posts to the buy_in endpoint' do
            http_middleware.expects(:post).with('buy_in', {})

            subject.buy_in('UUID', 1, 'USD', 5, 'Gold Coins')
          end

          before { http_middleware.stubs(:post) }

          it 'defaults payment_provider to Default Payment Provider' do
            subject.expects(:query_options).with('UUID', { cost: 1.to_f, local_currency: 'USD', reward_amount: 5.to_f, 
                                                           reward_currency: 'Gold Coins' , 
                                                           payment_provider: 'Default Payment Provider',
                                                          swrve_payload: {}.to_json})
            subject.buy_in('UUID', 1, 'USD', 5, 'Gold Coins')
          end

          it 'accepts payment_provider and swrve_payload values in the options' do
            subject.expects(:query_options).with('UUID', { cost: 1.to_f, local_currency: 'USD', reward_amount: 5.to_f, 
                                                           reward_currency: 'Gold Coins' , 
                                                           payment_provider: 'PayPal',
                                                          swrve_payload: { payload: '' }.to_json})

            subject.buy_in('UUID', 1, 'USD', 5, 'Gold Coins', payment_provider: 'PayPal', swrve_payload: {payload: nil})
          end
        end

        describe '#currency_given' do
          before { http_middleware.stubs(:post) }
          
          it 'validates the given_amount and the given_currency' do
            subject.expects(:validate_amount).with(1, "USD")

            subject.currency_given('UUID', 1, 'USD')
          end

          it 'builds the correct query options' do
            subject.expects(:fill_nil_values).with({}).returns({}.to_json)
            subject.expects(:query_options).with('UUID', { given_currency: 'USD', 
                                                           given_amount: 1, 
                                                           swrve_payload: {}.to_json })

            subject.currency_given('UUID', 1, 'USD')
          end

          before { subject.stubs(:query_options).returns({}) }

          it 'posts to the correct url' do
            http_middleware.expects(:post).with('currency_given', {})

            subject.currency_given('UUID', 1, 'Gold Coins')
          end
        end

        describe '#create_event' do
          
          before { http_middleware.stubs(:post) }
          
          it 'builds the correct query options' do
            subject.expects(:fill_nil_values).with({}).returns({}.to_json)
            subject.expects(:query_options).with('UUID', {name: 'event_name', swrve_payload: {}.to_json})

            subject.create_event('UUID', 'event_name')
          end

          before { subject.stubs(:query_options).returns({}) }

          it 'posts to the correct url' do            
            http_middleware.expects(:post).with('event', {})
            
            subject.create_event('UUID', 'event_name')
          end
        end
      end
    end
  end
end
