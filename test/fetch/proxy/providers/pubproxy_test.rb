require "test_helper"

require_relative 'proxy_response_stub'

describe Mine::Fetch::Proxy::Providers::Pubproxy do
  let :raw_response do
%<{"data":[{"ipPort":"117.2.22.41:41973","ip":"117.2.22.41","port":"41973","country":"VN","last_checked":"2019-05-31 00:01:03","proxy_level":"elite","type":"http","speed":"11","support":{"https":1,"get":1,"post":1,"cookies":1,"referer":1,"user_agent":1,"google":0}}],"count":1}>
  end

  let (:provider) { Mine::Fetch::Proxy::Providers::Pubproxy.new }

  let (:address) { Mine::Fetch::Proxy::Address.new("117.2.22.41", "41973") }

  it 'returns address' do
    provider.stub :fetch, ProxyResponseStub.new.(raw_response) do |provider|
      assert_equal address, provider.()
    end
  end
end
