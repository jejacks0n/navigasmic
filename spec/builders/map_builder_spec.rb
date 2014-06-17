require 'spec_helper'

describe 'Navigasmic::Builder::MapBuilder', type: :helper do

  subject { Navigasmic::Builder::MapBuilder }

  def clean(string)
    string.gsub(/\n(\s+)|\n|^\s+/, '')
  end

  describe "rendering" do

    it "outputs basic example" do
      builder = subject.new helper, :primary, {} do |n|
        n.group(class: 'group') { n.item "Label", '/path' }
        n.item('Level 1', class: 'item') { n.item 'Level 2' }
      end

      xml = <<-XML
        <urlset changefreq="yearly" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
          <url>
            <loc>http://test.host/path</loc>
            <name>Label</name>
          </url>
        </urlset>
      XML

      expect(builder.render).to match(clean(xml))
    end

    it "handles builder configurations" do
      builder = subject.new helper, :primary, {changefreq: 'weekly'} do |n|
        n.group('Group', class: 'group') { n.item "Label", '/path' }
        n.item('Level 1', class: 'item') { n.item 'Level 2' }
        n.item('Foo', '/other_path')
      end

      xml = <<-XML
        <urlset changefreq="weekly" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
          <url>
            <loc>http://test.host/path</loc>
            <name>Label</name>
          </url>
          <url>
            <loc>http://test.host/other_path</loc>
            <name>Foo</name>
          </url>
        </urlset>
      XML

      expect(builder.render).to match(clean(xml))
    end
  end
end
