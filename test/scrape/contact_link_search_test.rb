require "test_helper"

describe Mine::Scrape::ContactLinkSearch do
  let(:url) { 'http://www.xxx.com' }

  let(:path) { 'path/to/nowhere' }

  let(:about_path) { '/about/' }

  #let(:all_links) { %w(http://www.xxx.com/about/ http://www.xxx.com/path/to/nowhere) }
  let(:all_links) { [ "#{url}/about/", "#{url}/path/to/nowhere" ] }

  let :html do
    %(
      <li class="header"><a href="home/">Home</a></li>
      <li class="header-email"><a href="#{path}">Contact</a></li>
      <a href="#{about_path}">Click</a>
      <li class="header"><a href="away/">Away</a></li>
    )
  end

  let(:search) { Mine::Scrape::ContactLinkSearch.new html, url }

  it 'finds all' do
    assert_equal search.call, all_links
  end
end

