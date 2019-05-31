require "test_helper"

describe Mine::Fetch::Proxy::ProviderAddressLists do
  COUNT = 3

  def byte
    rand 256
  end
  def port
    rand(9999) + 1
  end

  def address_line
    "#{byte}.#{byte}.#{byte}.#{byte} #{port}"
  end

  def address_lines(count=COUNT)
    (1..count).map { address_line }
  end

  def provider(list=addresses, *args)
    Mine::Fetch::Proxy::ProviderAddressLists.new :list, list, *args
  end

  def to_address(ip, port)
    Mine::Fetch::Proxy::Address.new(ip, port)
  end

  let (:addresses) { address_lines }

  it 'returns address' do
    ip_and_port = addresses.first.split ' '

    assert_equal to_address(*ip_and_port), provider.()
  end

  it 'is alive at beginning' do
    provider = provider(address_lines 1)

    assert provider.()
    assert provider.alive?
  end

  it 'is dead at end' do
    provider = provider(address_lines)
    (1..COUNT).each { assert provider.() }

    refute provider.()
    assert provider.dead?
  end

  it 'accepts more than one list' do
    provider = provider(address_lines(1), address_lines(1))

    assert_equal 2, provider.addresses.size
  end

  it 'ignores empty lines' do
    line = address_line
    ip_and_port = line.split ' '

    provider = provider([' '], [ line ])

    assert_equal to_address(*ip_and_port), provider.()
    refute provider.()
  end

  it 'ignores commented lines' do
    line = address_line
    ip_and_port = line.split ' '

    provider = provider(['#1.2.3.4'], [ line ])

    assert_equal to_address(*ip_and_port), provider.()
    refute provider.()
  end
end
