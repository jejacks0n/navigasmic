require 'spec_helper'

describe 'Navigasmic::Builder::ListBuilder', type: :helper do

  subject { Navigasmic::Builder::ListBuilder }

  def clean(string)
    string.gsub(/\n(\s+)|\n|^\s+/, '')
  end

  describe "rendering" do

    it "outputs basic example" do
      builder = subject.new helper, :primary, {} do |n|
        n.group(class: 'group') { n.item "Label", '/path' }
        n.item('Level 1', class: 'item') { n.item 'Level 2' }
      end

      html = <<-HTML
        <ul class="semantic-navigation" id="primary">
          <li class="group has-nested">
            <ul class="is-nested">
              <li><a href="/path"><span>Label</span></a></li>
            </ul>
          </li>
          <li class="item has-nested">
            <span>Level 1</span>
            <ul class="is-nested">
              <li><span>Level 2</span></li>
            </ul>
          </li>
        </ul>
      HTML

      builder.render.should match(clean(html))
    end

    it "handles builder configurations" do
      builder = subject.new helper, :primary, {config: :bootstrap} do |n|
        n.group('Group', class: 'group') { n.item "Label", '/path' }
        n.item('Level 1', class: 'item') { n.item 'Level 2' }
        n.item('Foo')
        n.group(n.proc{"Dynamic Group"}) { n.item n.proc{'Label 3'} }
      end

      html = <<-HTML
        <ul class="nav nav-pills" id="primary">
          <li class="group dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Group<b class='caret'></b></a>
            <ul class="dropdown-menu">
              <li><a href="/path"><span>Label</span></a></li>
            </ul>
          </li>
          <li class="item dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Level 1<b class='caret'></b></a>
            <ul class="dropdown-menu">
              <li><span>Level 2</span></li>
            </ul>
          </li>
          <li><span>Foo</span></li>
          <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Dynamic Group<b class='caret'></b></a>
            <ul class="dropdown-menu">
              <li><span>Label 3</span></li>
            </ul>
          </li>
        </ul>
      HTML

      builder.render.should match(clean(html))
    end

    it "handles link_html of items" do
      builder = subject.new helper, :primary, {} do |n|
        n.item('Level 1', 'level1.html', class: 'item', link_html: {class: "dialog"})
      end

      html = <<-HTML
        <ul class="semantic-navigation" id="primary">
          <li class="item">
            <a class="dialog" href="level1.html">
              <span>Level 1</span>
            </a>
          </li>
        </ul>
      HTML

      builder.render.should match(clean(html))
    end
  end
end
