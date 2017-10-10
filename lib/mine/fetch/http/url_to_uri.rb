
require "uri"

module Mine
  module Fetch
    module Http
      module UrlToUri
        def uri
          raise "No URL" unless url

          URI === url ? url.dup : URI.parse(url)
        end
      end
    end
  end
end

