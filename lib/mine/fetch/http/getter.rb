
require 'net/http'

require 'mine/fetch/http/follow_redirect'
require "mine/fetch/http/url_to_uri"

module Mine
  module Fetch
    module Http
      class Getter < Struct.new(:url)
        include UrlToUri

        include FollowRedirect

        attr_accessor :http_response

        def call
          self.http_response = Net::HTTP.get_response uri

          if redirecting? Response.new(http_response)
            call
          else
            http_response.body
          end
        end

        def meta
          { url: uri.to_s, http_response: http_response, redirects: redirects }
        end
      end
    end
  end
end

