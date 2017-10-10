require "test_helper"

require_relative 'proxy_response_stub'

describe Mine::Fetch::Proxy::Providers::Getproxylist do
  let :raw_response do
%<{
    "_links": {
        "_self": "\/proxy",
        "_parent": "\/"
    },
    "ip": "46.151.114.98",
    "port": 53281,
    "protocol": "http",
    "anonymity": "high anonymity",
    "lastTested": "2017-06-22 18:15:24",
    "allowsRefererHeader": true,
    "allowsUserAgentHeader": true,
    "allowsCustomHeaders": true,
    "allowsCookies": true,
    "allowsPost": true,
    "allowsHttps": true,
    "country": "PL",
    "connectTime": "0.124",
    "downloadSpeed": "25.000",
    "secondsToFirstByte": "6.888",
    "uptime": "90.000"
}>
  end

  let (:provider) do
    Mine::Fetch::Proxy::Providers::Getproxylist.new(:getproxylist)
  end

  let (:address) { Mine::Fetch::Proxy::Address.new("46.151.114.98", "53281") }

  it 'returns address' do
    provider.stub :fetch, ProxyResponseStub.new.(raw_response) do |provider|
      assert_equal address, provider.()
    end
  end
end
