require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '#identify' do

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

          expect(stub).to have_been_requested
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

          expect(stub).to have_been_requested
        end
      end
    end

    context "when a distinct_id isn't provided" do

      context "when properties are provided" do
        it "raises an error" do
          trakio = Trakio.new 'my_api_token'
          expect { trakio.identify properties: { name: 'Tobie' } }.to raise_error Trakio::Exceptions::MissingParameter
        end
      end

    end

    context "when distinct_id and company_id are both set" do

      context "via arguments" do

        it "adds it to the company's people_distinct_ids" do
          stub = stub_request(:post, "https://api.trak.io/v1/identify").
            with(:body => {
              token: 'my_api_token',
              data: {
                distinct_id: 'user@example.com',
                properties: {
                  name: 'Tobie',
                  company: [{ company_id: 'massive_dynamics', role: 'widgets' }, { company_id: 'acme_ltd' }]
                },
              }
            }.to_json).to_return(:body => {
              status: 'success'
            }.to_json)

          trakio = Trakio.new 'my_api_token'
          trakio.identify distinct_id: 'user@example.com', company_id: 'acme_ltd', properties: { name: 'Tobie', company: { company_id: 'massive_dynamics', role: 'widgets' } }

          expect(stub).to have_been_requested
        end

      end

      context "via configuration" do

        it "adds it to the company's people_distinct_ids" do
          stub = stub_request(:post, "https://api.trak.io/v1/identify").
            with(:body => {
              token: 'my_api_token',
              data: {
                distinct_id: 'user@example.com',
                properties: {
                  name: 'Tobie',
                  company: [{ company_id: 'massive_dynamics', role: 'widgets' }, { company_id: 'monarch', role: 'widgets' }, { company_id: 'acme_ltd' }],
                },
              }
            }.to_json).to_return(:body => {
              status: 'success'
            }.to_json)

          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com', company_id: 'acme_ltd'
          trakio.identify properties: { name: 'Tobie', company: [{ company_id: 'massive_dynamics', role: 'widgets' }], companies: [{ company_id: 'monarch', role: 'widgets' }]  }

          expect(stub).to have_been_requested
        end

      end

      context "but company is also passed in properties" do

        it "doesn't send duplicates" do
          stub = stub_request(:post, "https://api.trak.io/v1/identify").
            with(:body => {
              token: 'my_api_token',
              data: {
                distinct_id: 'user@example.com',
                properties: {
                  name: 'Tobie',
                  company: [{ company_id: 'massive_dynamics', role: 'widgets' }, { company_id: 'monarch', role: 'widgets' }],
                },
              }
            }.to_json).to_return(:body => {
              status: 'success'
            }.to_json)

          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com', company_id: 'monarch'
          trakio.identify properties: { name: 'Tobie', company: [{ company_id: 'massive_dynamics', role: 'widgets' }], companies: [{ company_id: 'monarch', role: 'widgets' }]  }

          expect(stub).to have_been_requested
        end

      end

    end

  end

end
