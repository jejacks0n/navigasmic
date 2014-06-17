require 'spec_helper'

describe Navigasmic::Item do

  subject { Navigasmic::Item }

  describe "#hidden?" do
    it "returns true when it's not visible" do
      item = subject.new 'Label', {controller: 'controller'}, false
      expect(item.hidden?).to be true
    end

    it "returns false when it's visible" do
      item = subject.new 'Label', {controller: 'controller'}, true
      expect(item.hidden?).to be false
    end
  end

  describe "#disabled?" do
    it "returns true when it's disabled" do
      item = subject.new 'Label', {controller: 'controller'}, true, disabled_if: true
      expect(item.disabled?).to be true
    end

    it "returns false when it's not disabled" do
      item = subject.new 'Label', {controller: 'controller'}, true, disabled_if: false
      expect(item.disabled?).to be false
    end
  end

  describe "#link?" do
    it "returns true when there's a link" do
      item = subject.new 'Label', 'url', true
      expect(item.link?).to be true
    end

    it "returns false when there isn't a link" do
      item = subject.new 'Label', nil, true
      expect(item.link?).to be false
    end

    it "returns false when it's disabled" do
      item = subject.new 'Label', nil, true, disabled_if: true
      expect(item.link?).to be false
    end
  end

  describe "#calculate_highlighting_rules" do
    it "uses the item's link when no rules given" do
      item = subject.new 'Label', 'url', true
      expect(item.send(:calculate_highlighting_rules, nil)).to eq(['url'])
    end

    it "uses the given rules if any given" do
      item = subject.new 'Label', 'url', true, :highlights_on => false
      expect(item.send(:calculate_highlighting_rules, false)).to eq([false])

      item = subject.new 'Label', 'url', true, :highlights_on => false
      expect(item.send(:calculate_highlighting_rules, ["/a", "/b"])).to eq(["/a", "/b"])
    end
  end

  describe "#highlights_on?" do
    it "uses it's own link (as a string)" do
      item = subject.new 'Label', '/path', true
      expect(item.highlights_on?('/path', {})).to be true
      expect(item.highlights_on?('/other_path', {})).to be false
    end

    it "uses it's own path (as hash)" do
      item = subject.new 'Label', {controller: 'foo'}, true
      expect(item.highlights_on?('/path', {controller: 'foo'})).to be true
      expect(item.highlights_on?('/other_path', {controller: 'bar'})).to be false
    end

    it "highlights on multiple controllers" do
      item = subject.new 'Label', '/foo', true, highlights_on: [{controller: 'foo'}, {controller: 'bar'}]
      expect(item.highlights_on?('/path', {controller: 'foo'})).to be true
      expect(item.highlights_on?('/other_path', {controller: 'bar'})).to be true
      expect(item.highlights_on?('/other_path_entirely', {controller: 'baz'})).to be false
    end

    it "handles strings" do
      item = subject.new 'Label', '/foo', true, highlights_on: '/path'
      expect(item.highlights_on?('/path', {})).to be true
      expect(item.highlights_on?('/other_path', {})).to be false
    end

    it "handles regexp" do
      item = subject.new 'Label', '/foo', true, highlights_on: /^\/pa/
      expect(item.highlights_on?('/path', {})).to be true
      expect(item.highlights_on?('/other_path', {})).to be false
    end

    it "handles true/false" do
      item = subject.new 'Label', '/foo', true, highlights_on: true
      expect(item.highlights_on?('/path', {})).to be true
      expect(item.highlights_on?('/other_path', {})).to be true

      item = subject.new 'Label', '/foo', true, highlights_on: false
      expect(item.highlights_on?('/path', {})).to be false
      expect(item.highlights_on?('/other_path', {})).to be false
    end

    it "leaves controller paths alone (bug fix)" do
      item = subject.new 'Label', {controller: '/foo'}, true
      item.highlights_on?('/path', {})
      expect(item.link).to eq({controller: '/foo'})
    end
  end
end
