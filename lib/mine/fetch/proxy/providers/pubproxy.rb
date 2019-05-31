
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        # https://pubproxy.com/
        class Pubproxy < HttpProvider
          private

          def fetch
            get "http://pubproxy.com/api/proxy"
          end

          def values
            data&.values_at('ip', 'port')
          end

          def data
            parse_json(super)['data']&.first
          end
        end
      end
    end
  end
end
