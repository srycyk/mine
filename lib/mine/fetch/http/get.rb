
require 'net/http'

require 'mine/fetch/http/follow_redirect'
require "mine/fetch/http/url_to_uri"

module Mine
  module Fetch
    module Http
      class Get < Struct.new(:url)
        include UrlToUri

        include FollowRedirect

        def call
          response = get_response

          if redirecting? response
            call
          else
            response
          end
        end

        def get_response
          http_response = Net::HTTP.get_response uri

          Response.new http_response, method: 'GET',
                                      url: url,
                                      redirects: redirects
        end

      end
    end
  end
end

