require 'spec_helper'

describe Navigasmic::Item do

  subject { Navigasmic::Item }

  describe "#hidden?" do
    it "returns true when it's not visible" do
      item = subject.new 'Label', {controller: 'controller'}, false
      item.hidden?.should be(true)
    end

    it "returns false when it's visible" do
      item = subject.new 'Label', {controller: 'controller'}, true
      item.hidden?.should be(false)
    end
  end

  describe "#disabled?" do
    it "returns true when it's disabled" do
      item = subject.new 'Label', {controller: 'controller'}, true, disabled_if: true
      item.disabled?.should be(true)
    end

    it "returns false when it's not disabled" do
      item = subject.new 'Label', {controller: 'controller'}, true, disabled_if: false
      item.disabled?.should be(false)
    end
  end

  describe "#link?" do
    it "returns true when there's a link" do
      item = subject.new 'Label', 'url', true
      item.link?.should be(true)
    end

    it "returns false when there isn't a link" do
      item = subject.new 'Label', nil, true
      item.link?.should be(false)
    end

    it "returns false when it's disabled" do
      item = subject.new 'Label', nil, true, disabled_if: true
      item.link?.should be(false)
    end
  end

  describe "#calculate_highlighting_rules" do
    it "uses the item's link when no rules given" do
      item = subject.new 'Label', 'url', true
      item.send(:calculate_highlighting_rules, nil).should eq(['url'])
    end

    it "uses the given rules if any given" do
      item = subject.new 'Label', 'url', true, :highlights_on => false
      item.send(:calculate_highlighting_rules, false).should eq([false])

      item = subject.new 'Label', 'url', true, :highlights_on => false
      item.send(:calculate_highlighting_rules, ["/a", "/b"]).should eq(["/a", "/b"])
    end
  end

  describe "#highlights_on?" do
    it "uses it's own link (as a string)" do
      item = subject.new 'Label', '/path', true
      item.highlights_on?('/path', {}).should be(true)
      item.highlights_on?('/other_path', {}).should be(false)
    end

    it "uses it's own path (as hash)" do
      item = subject.new 'Label', {controller: 'foo'}, true
      item.highlights_on?('/path', {controller: 'foo'}).should be(true)
      item.highlights_on?('/other_path', {controller: 'bar'}).should be(false)
    end

    it "handles strings" do
      item = subject.new 'Label', '/foo', true, highlights_on: '/path'
      item.highlights_on?('/path', {}).should be(true)
      item.highlights_on?('/other_path', {}).should be(false)
    end

    it "handles regexp" do
      item = subject.new 'Label', '/foo', true, highlights_on: /^\/pa/
      item.highlights_on?('/path', {}).should be(true)
      item.highlights_on?('/other_path', {}).should be(false)
    end

    it "handles true/false" do
      item = subject.new 'Label', '/foo', true, highlights_on: true
      item.highlights_on?('/path', {}).should be(true)
      item.highlights_on?('/other_path', {}).should be(true)

      item = subject.new 'Label', '/foo', true, highlights_on: false
      item.highlights_on?('/path', {}).should be(false)
      item.highlights_on?('/other_path', {}).should be(false)
    end

    it "leaves controller paths alone (bug fix)" do
      item = subject.new 'Label', {controller: '/foo'}, true
      item.highlights_on?('/path', {})
      item.link.should == {controller: '/foo'}
    end
  end
end
