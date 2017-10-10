require "test_helper"

describe Mine::Fetch::Proxy::Address do
  let(:address) { Mine::Fetch::Proxy::Address.new("0.1.2.3", "4") }

  let(:the_name) { "of the game" }

  it 'returns ip and port as array' do
    assert_equal address.to_a, %w(0.1.2.3 4) 
  end

  it 'sets name' do
    assert_equal the_name, address.set_name(the_name).name
  end
end
