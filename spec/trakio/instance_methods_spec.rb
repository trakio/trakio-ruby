require 'spec_helper'

describe Trakio do

  subject { Trakio }

  after {
    Trakio.default_instance = nil
  }

  describe '#distinct_id=' do

    it "sets the distinct_id to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.distinct_id = 'user@example.com'
      expect(trakio.instance_variable_get('@distinct_id')).to eql 'user@example.com'
    end

    context "when this is the default Interface" do

      it "raises an exception" do
        Trakio.init 'my_api_token'
        expect{ Trakio.distinct_id = 'user@example.com' }.to raise_error Trakio::Exceptions::NoDistinctIdForDefaultInstance
      end

    end

  end

  describe '#distinct_id' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@distinct_id','user@example.com')
      expect(trakio.distinct_id).to eql 'user@example.com'
    end

  end

  describe '#channel=' do

    it "sets the channel to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.channel = 'my-channel'
      expect(trakio.instance_variable_get('@channel')).to eql 'my-channel'
    end

  end

  describe '#channel' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@channel','my-channel')
      expect(trakio.channel).to eql 'my-channel'
    end

  end

  describe '#https=' do

    it "sets whether https is to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.https = false
      expect(trakio.instance_variable_get('@https')).to be false
    end

  end

  describe '#https' do

    it "returns the current value" do
      trakio = Trakio.new 'api_token'
      trakio.instance_variable_set('@https',false)
      expect(trakio.https).to be false
    end

    it "defaults to true" do
      trakio = Trakio.new 'api_token'
      expect(trakio.https).to be true
    end

  end

  describe '#host=' do

    it "sets the host to be used by this Interface" do
      trakio = Trakio.new 'api_token'
      trakio.host = "lvh.me:3000"
      expect(trakio.instance_variable_get('@host')).to eql "lvh.me:3000"
    end

  end

  describe '#host' do

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
