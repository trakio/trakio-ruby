require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '#default_instance' do

    context "when a default instance hasn't been created" do
      it "raises an exception" do
        expect{ Trakio.default_instance }.to raise_error Trakio::Exceptions::Uninitiated
      end
    end

    context "when a default instance has already been created" do
      it "returns that" do
        Trakio.init 'my_api_token'
        expect(Trakio.default_instance).to be_a Trakio
      end
    end

  end

  describe '#init' do

    context "when an API token is provided" do

      it "creates a default Trakio::Interface" do
        Trakio.init 'my_api_token'
      end

      context "when a distinct_id is provided" do
        it "raises an exception" do
          expect{
            Trakio.init 'my_api_token', distinct_id: 'user@example.com'
          }.to raise_error Trakio::Exceptions::NoDistinctIdForDefaultInstance
        end
      end

      context "when a channel is provided" do
        it "sets the channel option" do
          Trakio.init 'my_api_token', channel: 'my-channel'
          expect(Trakio.channel).to eql 'my-channel'
        end
      end

      context "when a https is provided" do
        it "sets https option" do
          Trakio.init 'my_api_token', https: false
          expect(Trakio.https).to be_false
        end
      end

      context "when a https isn't provided" do
        it "defaults to true" do
          Trakio.init 'my_api_token'
          expect(Trakio.https).to be_true
        end
      end

      context "when a host is provided" do
        it "sets host option" do
          Trakio.init 'my_api_token', host: 'lvh.me:3007'
          expect(Trakio.host).to eql 'lvh.me:3007'
        end
      end

      context "when a host isn't provided" do
        it "defaults to api.trak.io/v1" do
          Trakio.init 'my_api_token'
          expect(Trakio.host).to eql 'api.trak.io/v1'
        end
      end

    end

    context "when an API token isn't provided" do
      it "raises an exception" do
        expect{ Trakio.init }.to raise_error Trakio::Exceptions::InvalidToken
      end
    end

  end

  describe '#track' do
    it "calls track on the default Trakio instance" do
      default_instance = double(Trakio)

      Trakio.default_instance = default_instance
      expect(Trakio.default_instance).to receive(:track)

      Trakio.track distinct_id: 'tobie.warburton@gmail.com', event: 'test-event'
    end
  end

  describe '#identify' do
    it "calls identify on the default Trakio instance" do
      default_instance = double(Trakio)

      Trakio.default_instance = default_instance
      expect(Trakio.default_instance).to receive(:identify)

      Trakio.identify
    end
  end

  describe '#alias' do
    it "calls alias on the default Trakio instance" do
      default_instance = double(Trakio)

      Trakio.default_instance = default_instance
      expect(Trakio.default_instance).to receive(:alias)

      Trakio.alias
    end
  end

  describe '#annotate' do

    it "calls annotate on the default Trakio instance" do
      default_instance = double(Trakio)

      Trakio.default_instance = default_instance
      expect(Trakio.default_instance).to receive(:annotate)

      Trakio.annotate
    end

  end

  describe '#page_view' do

    it "calls page_view on the default Trakio instance" do
      default_instance = double(Trakio)

      Trakio.default_instance = default_instance
      expect(Trakio.default_instance).to receive(:page_view)

      Trakio.page_view
    end

  end


  describe '#distinct_id' do
    it "raise an error" do
      expect{ Trakio.distinct_id }.to raise_error Trakio::Exceptions::NoDistinctIdForDefaultInstance
    end
  end

  describe '#channel' do

    it "calls channel on the default Trakio instance" do
      default_instance = double(Trakio)

      Trakio.default_instance = default_instance
      expect(Trakio.default_instance).to receive(:channel)

      Trakio.channel
    end

  end

end
