require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '.initialize' do

    context "when an API token is provided" do

      it "creates a new Trakio instance" do
        expect(Trakio.new "my_api_token").to be_a Trakio
      end

      it "sets the API token for this instance" do
        trakio = Trakio.new 'my_api_token'
        expect(trakio.api_token).to eql 'my_api_token'
      end


      context "when a channel is provided" do
        it "sets channel for this instance" do
          trakio = Trakio.new "my_api_token", channel: 'my-channel'
          expect(trakio.channel).to eql 'my-channel'
        end
      end

      context "when a distinct_id is provided" do
        it "sets that for this instance" do
          trakio = Trakio.new "my_api_token", distinct_id: 'user@example.com'
          expect(trakio.distinct_id).to eql 'user@example.com'
        end
      end

      context "when a https option is provided" do
        it "sets https option" do
          trakio = Trakio.new 'my_api_token', https: false
          expect(trakio.https).to be false
        end
      end

      context "when a https option isn't provided" do
        it "defaults to true" do
          trakio = Trakio.new 'my_api_token'
          expect(trakio.https).to be true
        end
      end

      context "when a host is provided" do
        it "sets host option" do
          trakio = Trakio.new 'my_api_token', host: 'lvh.me:3007'
          expect(trakio.host).to eql 'lvh.me:3007'
        end
      end

      context "when a host isn't provided" do
        it "defaults to api.trak.io/v1" do
          trakio = Trakio.new 'my_api_token'
          expect(trakio.host).to eql 'api.trak.io/v1'
        end
      end

    end

    context "when an API token isn't provided" do

      it "gets it from the default instance" do
        Trakio.init "my_api_token"
        trakio = Trakio.new
        expect(trakio.api_token).to eql 'my_api_token'
      end

      context "when there is no default instance" do
        it "raises an exception" do
          expect{ Trakio.new }.to raise_error Trakio::Exceptions::Uninitiated
        end
      end

    end

  end

end