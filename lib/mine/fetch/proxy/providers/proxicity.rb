
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        # proxicity.io
        class Proxicity < HttpProvider
          private

          def api_url
            "https://api.proxicity.io/v2/proxy?protocol=http&httpsSupport=true" #&port=443" #&country=UK"
          end

          def values
            json_data&.fetch('ipPort', '').split ':'
          end
        end
      end
    end
  end
end

