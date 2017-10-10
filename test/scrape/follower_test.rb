require "test_helper"

require_relative "task_helpers"

describe Mine::Scrape::Follower do
  include TaskHelpers

  def mappings
    { one: 'First', two: 'Second', three: 'Third' }
  end

  def follower(options=nil)
    Mine::Scrape::Follower.new(options || task_options)
  end

  def stub_follower(*args, &block)
    stub_task follower, *args, &block
  end

  def stub_follower_error(&block)
    stub_task_error follower, &block
  end

  before { reset }

  after { clean }

=begin
=end
  it 'spins through' do
    stub_follower response_for_site do |follower|
      follower.(site_list)

      assert follower.visit_list.finished?
      assert follower.visit_list.any?
    end
  end

  it 'stops at first' do
    stub_follower response_for_site do |follower|
      follower.(site_list) { true }

      refute follower.visit_list.finished?
      assert_equal sites.first, follower.visit_list.current
    end
  end

  it 'catches error (timeout)' do
    stub_follower nil do |follower|
      assert_raises(Mine::TooManyAttemptsError) { follower.(site_list) }
    end
  end

  it 'catches fetching error (http)' do
    stub_follower_error do |follower|
      assert_raises(Mine::TooManyAttemptsError) { follower.(site_list) }
    end
  end

  it 'uses proxy' do
    stub_follower response_for_site do |follower|
      set_proxy follower, 2

      follower.(site_list)

      assert follower.visit_list.finished?
    end
  end

  it 'runs out of proxies' do
    stub_follower response_for_site do |follower|
      set_proxy follower, 1

      assert_raises(Mine::NoMoreProxiesError) { follower.(site_list) }
    end
  end

  it 'logs sites' do
    output = []

    stub_follower response_for_site, output do |follower|
      follower.(site_list)

      (0...sites.size).each do |index|
        assert_match /\[#{sites[index]}\]/, output[index]
      end
    end
  end

  it 'logs proxies' do
    output = []

    stub_follower response_for_site, output do |follower|
      set_proxy follower, 2

      addresses = [ proxy_addresses.first, *proxy_addresses ]

      follower.(site_list)

      (0...sites.size).each do |index|
        assert_match /\(#{addresses[index]}\s/, output[index]
      end
    end
  end

  it 'removes items on error' do
    stub_task follower(task_options(true)), nil do |follower|
      follower.(site_list)

      assert follower.visit_list.none?
      assert follower.visit_list.finished?
    end
  end

  it '' do
  end
end

