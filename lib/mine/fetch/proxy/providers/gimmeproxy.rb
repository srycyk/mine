
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        class Gimmeproxy < HttpProvider
          private

          def api_url
            "http://gimmeproxy.com/api/getProxy?protocol=http&maxCheckPeriod=300&supportsHttps=true" #&port=80" #&country=UK"
          end
        end
      end
    end
  end
end

