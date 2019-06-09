require "test_helper"

require_relative 'proxy_response_stub'
require_relative 'proxy_helpers'
require_relative 'shared_proxy_assertions'

describe Mine::Fetch::Proxy::Providers::Pubproxy do
  include ProxyHelpers

  let :raw_response do
%<{"data":[{"ipPort":"117.2.22.41:41973","ip":"117.2.22.41","port":"41973","country":"VN","last_checked":"2019-05-31 00:01:03","proxy_level":"elite","type":"http","speed":"11","support":{"https":1,"get":1,"post":1,"cookies":1,"referer":1,"user_agent":1,"google":0}}],"count":1}>
  end

  let (:provider) { Mine::Fetch::Proxy::Providers::Pubproxy.new :pubproxy }

  let (:address) { proxy_address("117.2.22.41", "41973") }

  include SharedProxyAssertions
end
