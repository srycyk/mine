require "test_helper"

require_relative "task_helpers"

describe Mine::Scrape::Reducer do
  include TaskHelpers

  def mail
    "me@home.in"
  end

  def mappings
    { one: 'First', two: "<a href='mailto:#{mail}'>#{mail}</a>",
      three: 'Third', four: "<div>#{mail}</div>" }
  end

  def reducer(options=nil)
    Mine::Scrape::Reducer.new(options || task_options)
  end

  def stub_reducer(*args, &block)
    stub_task reducer, *args, &block
  end

  def stub_reducer_error(&block)
    stub_task_error reducer, &block
  end

  def predicate
    -> (html, *) { Mine::Scrape::EmailSearch.new(html).().any? }
  end

  before { reset }

  after { clean }

  it 'spins through' do
    stub_reducer response_for_site do |reducer|
      reducer.(site_list, predicate)

      assert reducer.visit_list.finished?

      assert_equal 2, reducer.visit_list.size
      assert_equal sites[1], reducer.visit_list.first
      assert_equal sites[3], reducer.visit_list.last
    end
  end

=begin
  it 'catches error (timeout)' do
    stub_reducer nil do |reducer|
      assert_raises(Mine::TooManyAttemptsError) { reducer.(site_list) }
    end
  end

  it 'catches fetching error (http)' do
    stub_reducer_error do |reducer|
      assert_raises(Mine::TooManyAttemptsError) { reducer.(site_list) }
    end
  end

  it 'uses proxy' do
    stub_reducer response_for_site do |reducer|
      set_proxy reducer, 2

      reducer.(site_list)

      assert reducer.visit_list.finished?
    end
  end

  it 'runs out of proxies' do
    stub_reducer response_for_site do |reducer|
      set_proxy reducer, 1

      assert_raises(Mine::NoMoreProxiesError) { reducer.(site_list) }
    end
  end

  it 'logs sites' do
    output = []

    stub_reducer response_for_site, output do |reducer|
      reducer.(site_list)

      (0...sites.size).each do |index|
        assert_match /\[#{sites[index]}\]/, output[index]
      end
    end
  end

  it 'logs proxies' do
    output = []

    stub_reducer response_for_site, output do |reducer|
      set_proxy reducer, 2

      addresses = [ proxy_addresses.first, *proxy_addresses ]

      reducer.(site_list)

      (0...sites.size).each do |index|
        assert_match /\(#{addresses[index]}\s/, output[index]
      end
    end
  end

  it 'removes items on error' do
    stub_task reducer(task_options(true)), nil do |reducer|
      reducer.(site_list)

      assert reducer.visit_list.none?
      assert reducer.visit_list.finished?
    end
  end

  it '' do
  end
=end
end

