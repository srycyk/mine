
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        # https://gimmeproxy.com/
        class Gimmeproxy < HttpProvider
          private

          def fetch
            get "http://gimmeproxy.com/api/getProxy?protocol=http&maxCheckPeriod=300&supportsHttps=true" #&port=80" #&country=UK"
          end

          def values
            data&.values_at('ip', 'port')
          end

          def data
            parse_json(super)
          end
        end
      end
    end
  end
end
