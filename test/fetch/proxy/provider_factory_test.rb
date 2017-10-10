require "test_helper"

describe Mine::Fetch::Proxy::ProviderFactory do
  let(:factory_class) { Mine::Fetch::Proxy::ProviderFactory }

  let(:factory) { factory_class.new }

  let(:provider_names) { factory_class::NAMES }

  let(:max_idx) { provider_names.size - 1 }

=begin
  it 'returns a provider type' do
    assert factory.().is_a? Mine::Fetch::Proxy::Provider
  end

  it 'resets name of factory if name given as call argument' do
    none_default_name = provider_names.last

    factory.(none_default_name)

    assert_equal none_default_name, factory.name
  end

  it 'returns first provider by default' do
    assert_equal provider_names.first, factory.().name
  end

  it 'returns last provider by name' do
    assert_equal provider_names.last, factory.(provider_names.last).name
  end

  it 'returns last provider by index' do
    count = provider_names.size * 3 - 1

    assert_equal provider_names.last, factory.(count).name
  end

  it 'passes name through' do
    assert_equal provider_names.first, factory.().name
  end

  it 'return block cycles providers' do
    block = factory_class.()

    (0..max_idx).each do |index|
      assert_equal provider_names[index], block.().name
    end
  end

  it 'return block recycles providers' do
    block = factory_class.()

    (0..max_idx).each {|index| block.().name }

    assert_equal provider_names.first, block.().name
  end
=end
end
