
require 'json'

require 'mine/fetch/proxy/provider'
require 'mine/fetch/http/get'
require 'mine/concerns/dead_or_alive'

module Mine
  module Fetch
    module Proxy
      class HttpProvider < Provider
        def call
          self.response = fetch

          response.saver.(name, with_time: true, deep_base: true)

          if http_okay?
            if address_okay?
              to_address values
            elsif banned?
              die
            end
          elsif not provider_okay?
            die
          end
        end

        private

        def get(url)
          Http::Get.new(url).()
        end

        def data
          response.body
        end

        def http_okay?
          response&.success?
        end

        def address_okay?
          values.any?
        end

        def provider_okay?
          true
        end

        def banned?
          false
        end
      end
    end
  end
end
