require 'spec_helper'

describe 'Navigasmic::Builder::Base', type: :helper do

  subject { Navigasmic::Builder::Base.new(helper, :primary, {}) {} }

  describe "#group" do

    it "raises" do
      expect { subject.group }.to raise_error('Expected subclass to implement group')
    end

  end

  describe "#item" do

    it "raises" do
      expect { subject.item }.to raise_error('Expected subclass to implement item')
    end

  end

  describe "#render" do

    it "raises" do
      expect { subject.render }.to raise_error('Expected subclass to implement render')
    end

  end

end
