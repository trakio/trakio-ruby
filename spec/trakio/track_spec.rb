require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '#track' do

    context "when a distinct_id is provided" do

      context "when an event is provided" do

        it "sends a track request to api.trak.io" do
          stub = stub_request(:post, "https://api.trak.io/v1/track").
            with(:body => {
              token: 'my_api_token',
              data: {
                time: /.+/,
                distinct_id: 'user@example.com',
                event: 'my-event'
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890'
            }.to_json)

          trakio = Trakio.new 'my_api_token'
          resp = trakio.track distinct_id: 'user@example.com', event: 'my-event'

          expect(resp[:status]).to eql 'success'
          expect(resp[:trak_id]).to eql '1234567890'

          expect(stub).to have_been_requested
        end

        context "when a channel is provided" do

          it "sends a track request to api.trak.io" do
            stub = stub_request(:post, "https://api.trak.io/v1/track").
              with(:body => {
                token: 'my_api_token',
                data: {
                  time: /.+/,
                  distinct_id: 'user@example.com',
                  event: 'my-event',
                  channel: 'my-channel'
                }
              }).to_return(:body => {
                status: 'success',
                trak_id: '1234567890'
              }.to_json)

            trakio = Trakio.new 'my_api_token'
            resp = trakio.track distinct_id: 'user@example.com', event: 'my-event',
              channel: 'my-channel'

            expect(resp[:status]).to eql 'success'
            expect(resp[:trak_id]).to eql '1234567890'

            expect(stub).to have_been_requested
          end

        end

        context "when a channel isn't provided and there is one on the instance" do

          it "sends a track request to api.trak.io" do
            stub = stub_request(:post, "https://api.trak.io/v1/track").
              with(:body => {
                token: 'my_api_token',
                data: {
                  time: /.+/,
                  distinct_id: 'user@example.com',
                  event: 'my-event',
                  channel: 'my-channel'
                }
              }).to_return(:body => {
                status: 'success',
                trak_id: '1234567890'
              }.to_json)

            trakio = Trakio.new "my_api_token", channel: 'my-channel'
            resp = trakio.track distinct_id: 'user@example.com', event: 'my-event'

            expect(resp[:status]).to eql 'success'
            expect(resp[:trak_id]).to eql '1234567890'

            expect(stub).to have_been_requested
          end

        end

        context "when properties are provided" do

          it "sends a track request to api.trak.io" do
            stub = stub_request(:post, "https://api.trak.io/v1/track").
              with(:body => {
                token: 'my_api_token',
                data: {
                  time: /.+/,
                  distinct_id: 'user@example.com',
                  event: 'my-event',
                  channel: 'my-channel',
                  properties: {
                    foo:  'bar'
                  }
                }
              }).to_return(:body => {
                status: 'success',
                trak_id: '1234567890'
              }.to_json)

            trakio = Trakio.new "my_api_token"
            resp = trakio.track distinct_id: 'user@example.com', event: 'my-event',
              channel: 'my-channel', properties: { foo: 'bar' }

            expect(resp[:status]).to eql 'success'
            expect(resp[:trak_id]).to eql '1234567890'

            expect(stub).to have_been_requested
          end

        end

        context "when a time is provided as a DateTime" do

          let (:time) { 3.days.ago }

          it "sends a track request to api.trak.io" do
            stub = stub_request(:post, "https://api.trak.io/v1/track").
              with(:body => {
                token: 'my_api_token',
                data: {
                  distinct_id: 'user@example.com',
                  event: 'my-event',
                  time: time.iso8601
                }
              }).to_return(:body => {
                status: 'success',
                trak_id: '1234567890'
              }.to_json)

            trakio = Trakio.new 'my_api_token'
            resp = trakio.track distinct_id: 'user@example.com', event: 'my-event', time: time

            expect(resp[:status]).to eql 'success'
            expect(resp[:trak_id]).to eql '1234567890'

            expect(stub).to have_been_requested
          end

        end

        context "when a time is provided as a string" do

          let (:time) { 3.days.ago }

          it "sends a track request to api.trak.io" do
            stub = stub_request(:post, "https://api.trak.io/v1/track").
              with(:body => {
                token: 'my_api_token',
                data: {
                  distinct_id: 'user@example.com',
                  event: 'my-event',
                  time: time.iso8601
                }
              }).to_return(:body => {
                status: 'success',
                trak_id: '1234567890'
              }.to_json)

            trakio = Trakio.new 'my_api_token'
            resp = trakio.track distinct_id: 'user@example.com', event: 'my-event', time: time.iso8601

            expect(resp[:status]).to eql 'success'
            expect(resp[:trak_id]).to eql '1234567890'

            expect(stub).to have_been_requested
          end

        end

      end

      context "when an event isn't provided" do

        it "raises an exception" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.track distinct_id: 'user@example.com' }.to raise_error RuntimeError
        end

      end

    end

    context "when a distinct_id isn't provided" do

      context "when an event is provided" do

        it "raises an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.track event: 'my-event' }.to raise_error RuntimeError
        end

      end

    end

    context "when a distinct_id isn't provided but its set on the instance" do

      context "when an event is provided" do

        it "sends a track request to api.trak.io" do
          stub = stub_request(:post, "https://api.trak.io/v1/track").
            with(:body => {
              token: 'my_api_token',
              data: {
                time: /.+/,
                distinct_id: 'user@example.com',
                event: 'my-event',
              }
            }).to_return(:body => {
              status: 'success',
              trak_id: '1234567890'
            }.to_json)

          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com'
          trakio.track event: 'my-event'

          expect(stub).to have_been_requested
        end

      end

    end

  end

end
