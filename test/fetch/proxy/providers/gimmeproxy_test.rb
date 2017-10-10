require "test_helper"

require_relative 'proxy_response_stub'

describe Mine::Fetch::Proxy::Providers::Gimmeproxy do
  let :raw_response do
%<{
  "get": true,
  "post": true,
  "cookies": true,
  "referer": true,
  "user-agent": true,
  "anonymityLevel": 1,
  "supportsHttps": true,
  "protocol": "http",
  "ip": "138.68.163.239",
  "port": "8118",
  "websites": {
    "example": true,
    "google": false,
    "amazon": true
  },
  "country": "GB",
  "tsChecked": 1497134106,
  "curl": "http://138.68.163.239:8118",
  "ipPort": "138.68.163.239:8118",
  "type": "http",
  "speed": 3.5,
  "otherProtocols": {}
}>
  end

  let (:provider) { Mine::Fetch::Proxy::Providers::Gimmeproxy.new }

  let (:address) { Mine::Fetch::Proxy::Address.new("138.68.163.239", "8118") }

  it 'returns address' do
    provider.stub :fetch, ProxyResponseStub.new.(raw_response) do |provider|
      assert_equal address, provider.()
    end
  end
end
