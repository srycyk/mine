require "test_helper"

require_relative 'proxy_response_stub'

describe Mine::Fetch::Proxy::Providers::Proxicity do
  let :raw_response do
    %<{"ipPort": "94.177.235.212:1189", "protocol": "http", "country": "RO", "userAgentSupport": true, "curl": "http://94.177.235.212:1189", "cookiesSupport": true, "postSupport": true, "supportedWebsites": {"bing.com": true, "craigslist.org": true, "pinterest.com": true, "reddit.com": true, "instagram.com": true, "youtube.com": true, "google.com": false, "yandex.com": true, "twitter.com": true, "amazon.com": true, "facebook.com": false, "github.com": true, "ebay.com": true, "linkedin.com": true}, "lastCheckedTimeStamp": "2017-06-12T14:20:07.075589", "httpsSupport": true, "isAnonymous": false, "refererSupport": true, "getSupport": true, "ipAddress": "94.177.235.212", "port": 1189, "speed": 3145.737}>
  end

  let (:provider) { Mine::Fetch::Proxy::Providers::Proxicity.new(:proxicity) }

  let (:address) { Mine::Fetch::Proxy::Address.new("94.177.235.212", "1189") }

  it 'returns address' do
    provider.stub :fetch, ProxyResponseStub.new.(raw_response) do |provider|
      assert_equal address, provider.()
    end
  end
end
