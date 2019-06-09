
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        class Pubproxy < HttpProvider
          API_URL = "http://pubproxy.com/api/proxy"

          private

          def values
            json_data&.fetch('data', nil)&.first&.values_at('ip', 'port')
          end
        end
      end
    end
  end
end
