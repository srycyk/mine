require "test_helper"

require_relative 'proxy_response_stub'
require_relative 'proxy_helpers'
require_relative 'shared_proxy_assertions'

describe Mine::Fetch::Proxy::Providers::Byteproxies do
  include ProxyHelpers

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

  let (:provider) { Mine::Fetch::Proxy::Providers::Byteproxies.new :byteproxies }

  let (:address) { proxy_address("190.60.103.178", 8080) }

  include SharedProxyAssertions
end

