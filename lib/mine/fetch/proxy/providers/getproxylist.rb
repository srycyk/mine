
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        class Getproxylist < HttpProvider
          private

          def fetch
            get "https://api.getproxylist.com/proxy?protocol=http" #&country=UK"
          end

          def values
            data&.values_at('ip', 'port').map(&:to_s)
          end

          def data
            parse_json(super)
          end
        end
      end
    end
  end
end
