
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        class Byteproxies < HttpProvider
          private

          def api_url
            "https://byteproxies.com/api.php?key=free&amount=1&type=http&anonymity=elite"
          end

          def values
            if hash = json_data&.first
              hash['response']&.values_at('ip', 'port')
            end
          end
        end
      end
    end
  end
end
