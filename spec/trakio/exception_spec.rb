require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '.track' do

    context "when an error is returned by the API" do
      it "raises an exception" do
        stub = stub_request(:post, "https://api.trak.io/v1/track").
          with(:body => {
            token: 'my_api_token',
            data: {
              time: /.+/,
              distinct_id: 'user@example.com',
              event: 'my-event'
            }
          }).to_return(:body => {
            status: 'error',
            code: 401,
            exception: "TrakioAPI::Exceptions::InvalidToken",
            message: "Missing or invalid API token.",
            details: "You must provide a valid API token, see http://docs.trak.io/authentication.html."
          }.to_json)

        trakio = Trakio.new 'my_api_token'
        expect {
          trakio.track distinct_id: 'user@example.com', event: 'my-event'
        }.to raise_error Trakio::Exceptions::InvalidToken

        expect(stub).to have_been_requested

      end
    end

    context "when no error is returned by the API" do
      it "returns the result" do
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
    end

  end # end .track
end
