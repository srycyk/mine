require "test_helper"

require_relative 'proxy_response_stub'

describe Mine::Fetch::Proxy::Providers::Byteproxies do
  let :raw_response do
%<[
    {
        "success": true,
        "response": {
            "ip": "190.60.103.178",
            "port": 8080,
            "type": "http",
            "anonymity": "elite",
            "country": "Colombia",
            "country_code": "CO",
            "load": 4.1729,
            "checked": "11:00:50 30.05.2019"
        }
    }
]>
  end

  let (:provider) { Mine::Fetch::Proxy::Providers::Byteproxies.new }

  let (:address) { Mine::Fetch::Proxy::Address.new("190.60.103.178", 8080) }

  it 'returns address' do
    provider.stub :fetch, ProxyResponseStub.new.(raw_response) do |provider|
      assert_equal address, provider.()
    end
  end
end
