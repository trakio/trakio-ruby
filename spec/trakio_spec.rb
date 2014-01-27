require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    # Remove the default instance
  }

  describe '#default_instance' do

    context "when a default instance hasn't been created" do
      it "raises an exception" do
        expect{ Trakio.default_instance }.to raise_error Trakio::Exceptions::UnInitiated
        pending
      end
    end

    context "when a default instance has already been created" do
      it "returns that" do
        pending
      end
    end

  end

  describe '#init' do

    context "when an API token is provided" do

      it "creates a default Trakio::Interface" do
        Trakio.init 'my_api_token'
        pending
      end

      context "when a distinct_id is provided" do

        it "raises an exception" do
          expect{ Trakio.init 'my_api_token', distinct_id: 'user@example.com' }.to raise_error Trakio::Exceptions::NoDistinctIdForDefaultInstance
          pending
        end

      end

      context "when a channel is provided" do

        it "sets the channel option" do
          Trakio.init 'my_api_token', channel: 'my-channel'
          expect(Trakio.channel).to eql 'my-channel'
          pending
        end

      end

      context "when a https is provided" do

        it "sets https option" do
          Trakio.init 'my_api_token', https: false
          expect(Trakio.https).to be_false
          pending
        end

      end

      context "when a https isn't provided" do

        it "defaults to true" do
          Trakio.init 'my_api_token'
          expect(Trakio.https).to be_true
          pending
        end

      end

      context "when a host is provided" do

        it "sets host option" do
          Trakio.init 'my_api_token', host: 'lvh.me:3007'
          expect(Trakio.host).to eql 'lvh.me:3007'
          pending
        end

      end

      context "when a host isn't provided" do

        it "defaults to api.trak.io/v1" do
          Trakio.init 'my_api_token'
          expect(Trakio.host).to eql 'api.trak.io/v1'
          pending
        end

      end

    end

    context "when an API token isn't provided" do

      it "raises an exception" do
        expect{ Trakio.init }.to raise_error Trakio::Exceptions::MissingApiToken
        pending
      end

    end

  end

  describe '#track' do

    it "calls track on the default Trakio instance" do
      pending
    end

  end

  describe '#identify' do

    it "calls alias on the default Trakio instance" do
      pending
    end

  end

  describe '#alias' do

    it "calls alias on the default Trakio instance" do
      pending
    end

  end

  describe '#annotate' do

    it "calls annotate on the default Trakio instance" do
      pending
    end

  end

  describe '#page_view' do

    it "calls annotate on the default Trakio instance" do
      pending
    end

  end


  describe '#distinct_id' do

    it "raise an error" do
      expect{ Trakio.distinct_id }.to raise_error Trakio::Exceptions::NoDistinctIdForDefaultInstance
      pending
    end

  end

  describe '#channel' do

    it "calls channel on the default Trakio instance" do
      pending
    end

  end

  describe '.initialize' do

    context "when an API token is provided" do

      it "creates a new Trakio instance" do
        expect(Trakio.new "my_api_token").to be_a Trakio
        pending
      end

      it "sets the API token for this instance" do
        trakio = Trakio.new 'my_api_token'
        expect(trakio.api_token).to eql 'my_api_token'
        pending
      end


      context "when a channel is provided" do

        it "sets channel for this instance" do
          trakio = Trakio.new "my_api_token", channel: 'my-channel'
          expect(trakio.channel).to eql 'my-channel'
          pending
        end

      end

      context "when a distinct_id is provided" do

        it "sets that for this instance" do
          Trakio.new "my_api_token", distinct_id: 'user@example.com'
          expect(trakio.distinct_id).to eql 'user@example.com'
          pending
        end

      end

      context "when a https option is provided" do

        it "sets https option" do
          trakio = Trakio.new 'my_api_token', https: false
          expect(trakio.https).to be_false
          pending
        end

      end

      context "when a https option isn't provided" do

        it "defaults to true" do
          trakio = Trakio.new 'my_api_token'
          expect(trakio.https).to be_true
          pending
        end

      end

      context "when a host is provided" do

        it "sets host option" do
          trakio = Trakio.new 'my_api_token', host: 'lvh.me:3007'
          expect(trakio.host).to eql 'lvh.me:3007'
          pending
        end

      end

      context "when a host isn't provided" do

        it "defaults to api.trak.io/v1" do
          trakio = Trakio.new 'my_api_token'
          expect(trakio.host).to eql 'api.trak.io/v1'
          pending
        end

      end

    end

    context "when an API token isn't provided" do

      it "gets it from the default instance" do
        Trakio.init "my_api_token"
        trakio = Trakio.new
        expect(trakio.api_token).to eql 'my_api_token'
        pending
      end

      context "when there is no default instance" do
        it "raises an exception" do
          expect{ Trakio.new }.to raise_error Trakio::Exceptions::UnInitiated
          pending
        end
      end

    end


  end


  describe '.track' do

    context "when a distinct_id is provided" do

      context "when an event is provided" do

        it "sends a track requst to api.trak.io" do
          trakio.track 'user@example.com', 'my-event'
          pending
        end

        context "when a channel is provided" do

          it "sends a track requst to api.trak.io" do
            trakio = Trakio.new 'my_api_token'
            trakio.track 'user@example.com', 'my-event', 'my-channel'
            pending
          end

        end

        context "when a channel isn't provided and there is one on the instance" do

          it "sends a track requst to api.trak.io" do
            trakio = Trakio.new 'my_api_token', channel: 'my-channel'
            trakio.track 'user@example.com', 'my-event'
            pending
          end

        end

        context "when properties are provided" do

          it "sends a track requst to api.trak.io" do
            trakio = Trakio.new 'my_api_token'
            trakio.track 'user@example.com', 'my-event', 'my-channel', { foo: 'bar' }
            pending
          end

        end

        context "when arguments are provided as a hash" do

          it "sends a track requst to api.trak.io" do
            trakio = Trakio.new 'my_api_token'
            trakio.track distinct_id: 'user@example.com', event: 'my-event', channel: 'my-channel', properties: { foo: 'bar' }
            pending
          end

        end

      end

      context "when an event isn't provided" do

        it "raises an exception" do
          trakio = Trakio.new 'my_api_token'
          trakio.track 'user@example.com'
          pending
        end

    end

    context "when a distinct_id isn't provided" do

      context "when an event is provided" do

        it "raises an error" do
          trakio = Trakio.new 'my_api_token'
          trakio.track 'my-event'
          pending
        end

      end

    end

    context "when a distinct_id isn't provided but its set on the instance" do

      context "when an event is provided" do

        it "sends a track requst to api.trak.io" do
          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com'
          trakio.track 'my-event'
          pending
        end

      end

    end

  end

  describe '.identify' do

    pending

  end

  describe '.alias' do

    pending

  end

  describe '.annotate' do

    pending

  end

  describe '.page_view' do

    pending

  end

  describe '.distinct_id=' do

    it "sets the distinct_id to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.distinct_id = 'user@example.com'
      expect(trakio.instance_variable_get('@distinct_id')).to eql 'user@example.com'
      pending
    end

    context "when this is the default Interface" do

      it "raises an exception" do
        expect{ Trakio.default_instance.distinct_id = 'user@example.com' }.to raise_error Trakio::Exceptions::NoDistinctIdForDefaultInstance
      end

    end

  end

  describe '.distinct_id' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@distinct_id','user@example.com')
      expect(trakio.distinct_id).to eql 'user@example.com'
      pending
    end

  end

  describe '.channel=' do

    it "sets the channel to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.channel = 'my-channel'
      expect(trakio.instance_variable_get('@channel')).to eql 'my-channel'
      pending
    end

  end

  describe '.channel' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@channel','my-channel')
      expect(trakio.channel).to eql 'my-channel'
      pending
    end

  end

  describe '.https=' do

    it "sets whether https is to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.https = false
      expect(trakio.instance_variable_get('@https')).to be_false
      pending
    end

  end

  describe '.https' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@https',false)
      expect(trakio.https).to be_false
      pending
    end

    it "defaults to true" do
      trakio = Trakio.new 'api_token'
      expect(trakio.https).to be_true
      pending
    end

  end

  describe '.host=' do

    it "sets the host to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.host = "lvh.me:3000"
      expect(trakio.instance_variable_get('@host')).to "lvh.me:3000"
      pending
    end

  end

  describe '.host' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@host',"lvh.me:3000")
      expect(trakio.host).to eql "lvh.me:3000"
      pending
    end

    it "defaults to api.trak.io/v1" do
      trakio = Trakio.new 'api_token'
      expect(trakio.host).to eql "api.trak.io/v1"
      pending
    end

  end

end
