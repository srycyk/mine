
require 'mine/fetch/proxy/http_provider'

module Mine
  module Fetch
    module Proxy
      module Providers
        class Getproxylist < HttpProvider
          private

          def api_url
            "https://api.getproxylist.com/proxy?protocol=http" #&country=UK"
          end

          def values
            json_values&.map(&:to_s)
          end
        end
      end
    end
  end
end
