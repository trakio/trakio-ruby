require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '#default_instance' do

    context "when a default instance hasn't been created" do
      it "raises an exception" do
        expect{ Trakio.default_instance }.to raise_error Trakio::Exceptions::UnInitiated
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
        expect{ Trakio.init }.to raise_error Trakio::Exceptions::MissingApiToken
      end

    end

  end

  describe '#track' do
    it "calls track on the default Trakio instance" do
      default_instance = double(Trakio)

      Trakio.default_instance = default_instance
      expect(Trakio.default_instance).to receive(:track)

      Trakio.track
    end
  end

  describe '#identify' do
    it "calls alias on the default Trakio instance" do
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
          expect(trakio.https).to be_false
        end
      end

      context "when a https option isn't provided" do
        it "defaults to true" do
          trakio = Trakio.new 'my_api_token'
          expect(trakio.https).to be_true
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
          expect{ Trakio.new }.to raise_error Trakio::Exceptions::UnInitiated
        end
      end
    end

  end


  describe '.track' do

    context "when a distinct_id is provided" do

      context "when an event is provided" do

        it "sends a track requst to api.trak.io" do
          pending
          trakio.track 'user@example.com', 'my-event'
        end

        context "when a channel is provided" do

          it "sends a track requst to api.trak.io" do
            pending
            trakio = Trakio.new 'my_api_token'
            trakio.track 'user@example.com', 'my-event', 'my-channel'
          end

        end

        context "when a channel isn't provided and there is one on the instance" do

          it "sends a track requst to api.trak.io" do
            pending
            trakio = Trakio.new 'my_api_token', channel: 'my-channel'
            trakio.track 'user@example.com', 'my-event'
          end

        end

        context "when properties are provided" do

          it "sends a track requst to api.trak.io" do
            pending
            trakio = Trakio.new 'my_api_token'
            trakio.track 'user@example.com', 'my-event', 'my-channel', { foo: 'bar' }
          end

        end

        context "when arguments are provided as a hash" do

          it "sends a track requst to api.trak.io" do
            pending
            trakio = Trakio.new 'my_api_token'
            trakio.track distinct_id: 'user@example.com', event: 'my-event', channel: 'my-channel', properties: { foo: 'bar' }
          end

        end

      end

      context "when an event isn't provided" do

        it "raises an exception" do
          pending
          trakio = Trakio.new 'my_api_token'
          trakio.track 'user@example.com'
        end

      end

    end

    context "when a distinct_id isn't provided" do

      context "when an event is provided" do

        it "raises an error" do
          pending
          trakio = Trakio.new 'my_api_token'
          trakio.track 'my-event'
        end

      end

    end

    context "when a distinct_id isn't provided but its set on the instance" do

      context "when an event is provided" do

        it "sends a track requst to api.trak.io" do
          pending
          trakio = Trakio.new 'my_api_token', distinct_id: 'user@example.com'
          trakio.track 'my-event'
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
    end

    context "when this is the default Interface" do

      it "raises an exception" do
        pending
        Trakio.init 'my_api_token'
        expect{ Trakio.default_instance.distinct_id = 'user@example.com' }.to raise_error Trakio::Exceptions::NoDistinctIdForDefaultInstance
      end

    end

  end

  describe '.distinct_id' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@distinct_id','user@example.com')
      expect(trakio.distinct_id).to eql 'user@example.com'
    end

  end

  describe '.channel=' do

    it "sets the channel to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.channel = 'my-channel'
      expect(trakio.instance_variable_get('@channel')).to eql 'my-channel'
    end

  end

  describe '.channel' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@channel','my-channel')
      expect(trakio.channel).to eql 'my-channel'
    end

  end

  describe '.https=' do

    it "sets whether https is to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.https = false
      expect(trakio.instance_variable_get('@https')).to be_false
    end

  end

  describe '.https' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@https',false)
      expect(trakio.https).to be_false
    end

    it "defaults to true" do
      trakio = Trakio.new 'api_token'
      expect(trakio.https).to be_true
    end

  end

  describe '.host=' do

    it "sets the host to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.host = "lvh.me:3000"
      expect(trakio.instance_variable_get('@host')).to eql "lvh.me:3000"
    end

  end

  describe '.host' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@host',"lvh.me:3000")
      expect(trakio.host).to eql "lvh.me:3000"
    end

    it "defaults to api.trak.io/v1" do
      trakio = Trakio.new 'api_token'
      expect(trakio.host).to eql "api.trak.io/v1"
    end

  end

end
