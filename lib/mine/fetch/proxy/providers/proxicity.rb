
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        class Proxicity < HttpProvider
          private

          def fetch
            get "https://api.proxicity.io/v2/proxy?protocol=http&httpsSupport=true" #&port=443" #&country=UK"
          end

          def values
            data&.fetch('ipPort', '').split ':'
          end

          def data
            parse_json(super)
          end
        end
      end
    end
  end
end

