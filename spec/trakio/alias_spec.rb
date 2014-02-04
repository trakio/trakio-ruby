require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '.alias' do

    context "when an array alias is provided" do
      it "sends an array" do
        stub = stub_request(:post, "https://api.trak.io/v1/alias").
          with(:body => {
            token: 'my_api_token',
            data: {
              distinct_id: 'user@example.com',
              alias: [
                'alias1@example.com',
              ],
            }
          }).to_return(:body => {
            status: 'success',
            trak_id: '1234567890',
            distinct_ids: ['user@example.com', 'alias1@example.com'],
          }.to_json)

        trakio = Trakio.new 'my_api_token'
        trakio.alias distinct_id: 'user@example.com', alias: ['alias1@example.com']

        stub.should have_been_requested
      end
    end

    context "when a string alias is provided" do
      it "sends a string" do
        stub = stub_request(:post, "https://api.trak.io/v1/alias").
          with(:body => {
            token: 'my_api_token',
            data: {
              distinct_id: 'user@example.com',
              alias: 'alias1@example.com',
            }
          }).to_return(:body => {
            status: 'success',
            trak_id: '1234567890',
            distinct_ids: ['user@example.com', 'alias1@example.com'],
          }.to_json)

        trakio = Trakio.new 'my_api_token'
        trakio.alias distinct_id: 'user@example.com', alias: 'alias1@example.com'

        stub.should have_been_requested
      end
    end

    context "when no alias is provided" do
      it "raises an error" do
        trakio = Trakio.new 'my_api_token'
        expect { trakio.alias distinct_id: 'user@example.com' }.to raise_error RuntimeError
      end
    end

    context "when no distinct_id is provided" do

      context "when there is one set on the instance" do
        it "sends a request" do
          stub = stub_request(:post, "https://api.trak.io/v1/alias").
            with(:body => {
              token: 'my_api_token',
              data: {
                distinct_id: 'user@example.com',
                alias: 'alias1@example.com',
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890',
              distinct_ids: ['user@example.com', 'alias1@example.com'],
            }.to_json)

          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com'
          trakio.alias alias: 'alias1@example.com'

          stub.should have_been_requested
        end
      end

      context "when there is not one set on the instance" do
        it "raises an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.alias alias: 'alias1@example.com' }.to raise_error RuntimeError
        end
      end

    end

  end
end
