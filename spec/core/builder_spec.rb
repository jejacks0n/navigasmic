require 'spec_helper'

describe 'Navigasmic::Builder::Base', type: :helper do

  subject { Navigasmic::Builder::Base.new(helper, :primary, {}) {} }

  describe "#group" do

    it "raises" do
      lambda { subject.group }.should raise_error('Expected subclass to implement group')
    end

  end

  describe "#item" do

    it "raises" do
      lambda { subject.item }.should raise_error('Expected subclass to implement item')
    end

  end

  describe "#render" do

    it "raises" do
      lambda { subject.render }.should raise_error('Expected subclass to implement render')
    end

  end

end
