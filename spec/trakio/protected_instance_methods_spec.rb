require 'spec_helper'

describe Trakio do

  subject { Trakio }
  let(:trakio) { Trakio.init 'my_api_token' }

  after { Trakio.default_instance = nil }

  before { Trakio.send(:public, *Trakio.protected_instance_methods) }

  describe '#distinct_id_from_parameters' do

    context "when the :distinct_id key is provided in parameters" do
      it "returns that value" do
        expect(trakio.distinct_id_from_parameters({ distinct_id: 'my_distinct_id'})).to eq 'my_distinct_id'
      end
    end

    context "when the :distinct_id key isn't provided in parameters" do

      it "returns @distinct_id" do
        trakio.distinct_id = 'other_distinct_id'
        expect(trakio.distinct_id_from_parameters({ distinct_id: nil})).to eq 'other_distinct_id'
      end


      context "and @distinct_id has not been set" do

        it "raises an exception" do
          expect{ trakio.distinct_id_from_parameters({ distinct_id: nil}) }.to raise_error RuntimeError
        end

      end

    end

  end

end
