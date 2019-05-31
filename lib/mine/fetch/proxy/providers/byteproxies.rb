
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        # https://byteproxies.com/
        class Byteproxies < HttpProvider
          private

          def fetch
            get "https://byteproxies.com/api.php?key=free&amount=1&type=http&anonymity=elite"
          end

          def values
            (data['response'] || {}).values_at('ip', 'port')
          end

          def data
            parse_json(super)&.first #['response']
          end
        end
      end
    end
  end
end
