
require_relative "../support/html_example"

class SiteToContent
  attr_accessor :mappings

  def initialize(mappings=nil)
    self.mappings = mappings || {}
  end

  def call(site)
    content(mappings[find_path site])
  end

  def to_site(path)
    "http://host.co.uk/page/#{path}"
  end

  def content(excerpt)
    HtmlExample.new.(excerpt)
  end

  def sites
    mappings.keys.map {|path| to_site path }
  end

  def find_path(site)
    mappings.keys.each do |path|
      return path if site == to_site(path)
    end
    nil
  end

  def to_s
    mappings.inspect
  end
end
