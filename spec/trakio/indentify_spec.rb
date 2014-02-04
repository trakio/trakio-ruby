require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '.identify' do

    context "when a distinct_id is provided" do
      context "when properties are provided" do
        it "sends an identify request" do
          stub = stub_request(:post, "https://api.trak.io/v1/identify").
            with(:body => {
              token: 'my_api_token',
              data: {
                distinct_id: 'user@example.com',
                properties: {
                  name: 'Tobie',
                },
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890',
              distinct_ids: ['user@example.com'],
            }.to_json)

          trakio = Trakio.new 'my_api_token'
          trakio.identify distinct_id: 'user@example.com', properties: { name: 'Tobie' }

          stub.should have_been_requested
        end
      end
    end

    context "when a distinct_id isn't provided but is set on instance" do
      context "when properties are provided" do
        it "sends an identify request" do
          stub = stub_request(:post, "https://api.trak.io/v1/identify").
            with(:body => {
              token: 'my_api_token',
              data: {
                distinct_id: 'user@example.com',
                properties: {
                  name: 'Tobie',
                },
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890',
              distinct_ids: ['user@example.com'],
            }.to_json)

          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com'
          trakio.identify properties: { name: 'Tobie' }

          stub.should have_been_requested
        end
      end
    end

    context "when a distinct_id isn't provided" do

      context "when properties are provided" do
        it "raises an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.identify properties: { name: 'Tobie' } }.to raise_error RuntimeError
        end
      end

      context "when properties aren't provided" do
        it "raises an error" do
          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com'
          expect { trakio.identify }.to raise_error ArgumentError
        end
      end

    end

  end

end
