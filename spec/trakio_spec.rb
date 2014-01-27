require 'spec_helper'

describe Trakio do

  include Trakio

  describe '#hello' do

    subject { hello }

    it { should eql "Hello World!" }

  end

end
