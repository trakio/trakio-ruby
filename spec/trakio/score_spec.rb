require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '#score' do

    context "when a distinct_id is provided as an argument" do

      it "sends a score request to api.trak.io" do
        stub = stub_request(:get, "https://api.trak.io/v1/score").
          with(:body => {
            key: 'my_api_secret_key',
            distinct_id: 'a_person'
          }).to_return(:body => {
            status: 'success'
          }.to_json)

        trakio = Trakio.new 'my_api_token', 'my_api_secret_key'
        resp = trakio.score distinct_id: 'a_person'

        expect(resp[:status]).to eql 'success'

        expect(stub).to have_been_requested
      end

    end

    context "when a company_id is provided as an argument" do

      it "sends a score request to api.trak.io" do
        stub = stub_request(:get, "https://api.trak.io/v1/score").
          with(:body => {
            key: 'my_api_secret_key',
            company_id: 'a_company'
          }).to_return(:body => {
            status: 'success'
          }.to_json)

        trakio = Trakio.new 'my_api_token', 'my_api_secret_key'
        resp = trakio.score company_id: 'a_company'

        expect(resp[:status]).to eql 'success'

        expect(stub).to have_been_requested
      end

    end

    context "when both a company_id and distinct_id are provided as arguments" do

      it "raises an error" do
        trakio = Trakio.new 'my_api_token', 'my_api_secret_key'
        expect(trakio.score distinct_id: 'a_person', company_id: 'a_company').to have_been_requested
      end

    end

    context "when neither distinct_id or company_id is provided" do

      it "raises an error" do
        trakio = Trakio.new 'my_api_token', 'my_api_secret_key'
        expect { trakio.score }.to raise_error Trakio::Exceptions::MissingParameter
      end

    end

  end

end
