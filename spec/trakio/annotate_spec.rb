require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }
  
	describe '.annotate' do

    context "when an event is provided" do

      context "when a channel is provided" do
        it "should send a request with the channel" do
          stub = stub_request(:post, "https://api.trak.io/v1/annotate").
            with(:body => {
            token: 'my_api_token',
            data: {
              event: 'event',
              channel: 'channel',
              properties: {},
            }
          }).to_return(:body => {
            status: 'success',
            trak_id: '1234567890',
          }.to_json)

          trakio = Trakio.new 'my_api_token'
          trakio.annotate event: 'event', channel: 'channel'

          stub.should have_been_requested
        end
      end

      context "when a channel isnt provided" do
        context "when there is a channel set on the instance" do
          it "should send a request with the channel" do
            stub = stub_request(:post, "https://api.trak.io/v1/annotate").
              with(:body => {
              token: 'my_api_token',
              data: {
                event: 'event',
                channel: 'channel',
                properties: {},
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890',
            }.to_json)

            trakio = Trakio.new 'my_api_token', channel: 'channel'
            trakio.annotate event: 'event'

            stub.should have_been_requested
          end
        end
      end

      context "when properties are provided" do
        it "should send a request with the properties" do
          stub = stub_request(:post, "https://api.trak.io/v1/annotate").
            with(:body => {
              token: 'my_api_token',
              data: {
                event: 'event',
                properties: {
                  details: 'details',
                },
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890',
            }.to_json)

          trakio = Trakio.new 'my_api_token'
          trakio.annotate event: 'event', properties: { details: 'details' }

          stub.should have_been_requested
        end
      end

      context "when properties are not provided" do
        it "should send a request with empty properties" do
          stub = stub_request(:post, "https://api.trak.io/v1/annotate").
            with(:body => {
              token: 'my_api_token',
              data: {
                event: 'event',
                properties: {},
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890',
            }.to_json)

          trakio = Trakio.new 'my_api_token'
          trakio.annotate event: 'event'

          stub.should have_been_requested
        end
      end

    end

    context "when an event is not provided" do

      context "when a channel is provided" do
        it "should raise an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.annotate channel: 'channel' }.to raise_error RuntimeError
        end
      end

      context "when properties are provided" do
        it "should raise an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.annotate properties: { name: 'tobie' } }.to raise_error RuntimeError
        end
      end

      context "when no arguments are provided" do
        it "should raise an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.annotate }.to raise_error ArgumentError
        end
      end

    end

  end

end