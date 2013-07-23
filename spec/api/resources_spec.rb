require 'spec_helper'
require 'swrve/middleware/http'
module Swrve
  module Api
    describe Resources do
      
      subject { Resources.new }
      
      describe '.new' do       
        let(:config) { stub_everything('config', ab_test_url: 'http://ab_test_url', api_version: 1) }

        before do
          Swrve.stubs(config: config)
        end

        it 'Creates a resources endpoint' do
          Middleware::Http.expects(:new).with([config.ab_test_url, 'api', config.api_version].join('/'))

          subject
        end
      end

      describe '#get' do
        let(:resources_endpoint) { mock('resources_endpoint') }

        before { Middleware::Http.stubs(:new).returns(resources_endpoint) }

        it 'delegates it to the resources endpoint' do
          resources_endpoint.expects(:get)
          
          subject.send(:get)
        end
      end
    end
  end
end
