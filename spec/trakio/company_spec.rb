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

      context "when distinct_id is provided" do

        context "via arguments" do

          it "adds it to the company's people_distinct_ids" do
            stub = stub_request(:post, "https://api.trak.io/v1/company").
              with(:body => {
                token: 'my_api_token',
                data: {
                  company_id: 'acme_ltd',
                  properties: {
                    name: 'Acme Ltd',
                  },
                  people_distinct_ids: ['existing_distinct_id','distinct_id']
                }
              }.to_json).to_return(:body => {
                status: 'success'
              }.to_json)

            trakio = Trakio.new 'my_api_token', company_id: 'not_the_company_id_to_use', distinct_id: 'not_the_distinct_id_to_use'
            trakio.company company_id: 'acme_ltd', distinct_id: 'distinct_id', properties: { name: 'Acme Ltd' }, people_distinct_ids: ['existing_distinct_id']

            expect(stub).to have_been_requested
          end

        end

        context "via configuration" do

          it "adds it to the company's people_distinct_ids" do
            stub = stub_request(:post, "https://api.trak.io/v1/company").
              with(body: {
                token: 'my_api_token',
                data: {
                  company_id: 'acme_ltd',
                  properties: {
                    name: 'Acme Ltd',
                  },
                  people_distinct_ids: ['existing_distinct_id', '1234','distinct_id']
                }
              }.to_json).to_return(:body => {
                status: 'success'
              }.to_json)

            trakio = Trakio.new 'my_api_token', company_id: 'acme_ltd', distinct_id: 'distinct_id'
            trakio.company properties: { name: 'Acme Ltd' }, people_distinct_ids: ['existing_distinct_id', 1234]

            expect(stub).to have_been_requested
          end

        end

        context "and is not an array" do

          it "raises an error" do
            trakio = Trakio.new 'my_api_token', company_id: 'acme_ltd'
            expect {
              trakio.company properties: { name: 'Acme Ltd' }, people_distinct_ids: 1234
            }.to raise_error Trakio::Exceptions::InvalidParameter
          end

        end

      end

    end

    context "when a company_id isn't provided" do

      context "when properties are provided" do
        it "raises an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.identify properties: { name: 'Acme Ltd' } }.to raise_error Trakio::Exceptions::MissingParameter
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
