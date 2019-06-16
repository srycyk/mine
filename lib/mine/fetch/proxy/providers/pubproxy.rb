
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        class Pubproxy < HttpProvider
          private

          def api_url
            "http://pubproxy.com/api/proxy"
          end

          def values
            json_data&.fetch('data', nil)&.first&.values_at('ip', 'port')
          end
        end
      end
    end
  end
end
