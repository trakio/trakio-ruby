require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '#company' do

    context "when a company_id is provided" do
      context "when properties are provided" do
        it "sends an company request" do
          stub = stub_request(:post, "https://api.trak.io/v1/company").
            with(:body => {
              token: 'my_api_token',
              data: {
                company_id: 'acme_ltd',
                properties: {
                  name: 'Acme Ltd',
                },
              }
            }).to_return(:body => {
              status: 'success'
            }.to_json)

          trakio = Trakio.new 'my_api_token'
          trakio.company company_id: 'acme_ltd', properties: { name: 'Acme Ltd' }

          expect(stub).to have_been_requested
        end
      end
    end

    context "when a company_id isn't provided but is set on instance" do
      context "when properties are provided" do
        it "sends an company request" do
          stub = stub_request(:post, "https://api.trak.io/v1/company").
            with(:body => {
              token: 'my_api_token',
              data: {
                company_id: 'acme_ltd',
                properties: {
                  name: 'Acme Ltd',
                },
              }
            }).to_return(:body => {
              status: 'success'
            }.to_json)

          trakio = Trakio.new 'my_api_token', company_id: 'acme_ltd'
          trakio.company properties: { name: 'Acme Ltd' }

          expect(stub).to have_been_requested
        end
      end
    end

    context "when a company_id isn't provided" do

      context "when properties are provided" do
        it "raises an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.identify properties: { name: 'Acme Ltd' } }.to raise_error RuntimeError
        end
      end

    end

    context "when properties aren't provided" do
      it "raises an error" do
        trakio = Trakio.new 'my_api_token', company_id: 'acme_ltd'
        expect { trakio.identify }.to raise_error ArgumentError
      end
    end

  end

end
