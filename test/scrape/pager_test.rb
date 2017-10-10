require "test_helper"

require_relative "task_helpers"

describe Mine::Scrape::Pager do
  include TaskHelpers

  def link(id, href)
    "<a id='#{id}' href='#{href}'>Next page</a>"
  end

  def mappings
    { one: link(:next, 'page/two'),
      two: link(:next, 'page/three'),
      three: 'Third' }
  end

  def pager(options=nil)
    Mine::Scrape::Pager.new(options || task_options)
  end

  def stub_pager(*args, &block)
    stub_task pager, *args, &block
  end

  def stub_pager_error(&block)
    stub_task_error pager, &block
  end

  def pager_block
    -> page, out {
      if ( link = page.css("a[id='next']") ).any?
        out << link.attr('href')
      end
    }
  end

  def pager_list
    site_list sites.values_at 0
  end

  before { reset }

  after { clean }

=begin
=end
  it 'spins through' do
    stub_pager response_for_site do |pager|
      pager.(pager_list, &pager_block)

      assert_equal sites, pager.visit_list.to_a
      assert pager.visit_list.finished?
    end
  end

  it 'catches error (timeout)' do
    stub_pager nil do |pager|
      assert_raises(Mine::TooManyAttemptsError) { pager.(pager_list) }
    end
  end

  it 'catches fetching error (http)' do
    stub_pager_error do |pager|
      assert_raises(Mine::TooManyAttemptsError) { pager.(pager_list) }
    end
  end

  it 'uses proxy' do
    stub_pager response_for_site do |pager|
      set_proxy pager, 2

      pager.(pager_list, &pager_block)

      assert pager.visit_list.finished?
    end
  end

  it 'runs out of proxies' do
    stub_pager response_for_site do |pager|
      set_proxy pager, 1

      assert_raises(Mine::NoMoreProxiesError) { pager.(pager_list, &pager_block) }
    end
  end

  it 'logs sites' do
    output = []

    stub_pager response_for_site, output do |pager|
      pager.(pager_list, &pager_block)

      (0...sites.size).each do |index|
        assert_match /\[#{sites[index]}\]/, output[index]
      end
    end
  end

  it 'logs proxies' do
    output = []

    stub_pager response_for_site, output do |pager|
      set_proxy pager, 2

      addresses = [ proxy_addresses.first, *proxy_addresses ]

      pager.(pager_list, &pager_block)

      (0...sites.size).each do |index|
        assert_match /\(#{addresses[index]}\s/, output[index]
      end
    end
  end

  it 'removes items on error' do
    stub_task pager(task_options(true)), nil do |pager|
      pager.(pager_list, &pager_block)

      assert pager.visit_list.none?
      assert pager.visit_list.finished?
    end
  end

  it '' do
  end
end

