
require 'net/http'

require "mine/fetch/http/url_to_uri"

module Mine
  module Fetch
    module Http
      class AgentBase < Struct.new(:url, :attributes)
        include UrlToUri

        attr_accessor :current_uri, :proxy_address

        def initialize(*)
          super

          set_uri

          self.proxy_address = attributes[:proxy] if attributes&.key? :proxy
        end

        def set_uri
          self.current_uri = uri
        end

        def http_request
          begin
            proxy_address ? proxy_http_request : direct_http_request
          rescue Net::ReadTimeout, Net::OpenTimeout,
                 Net::HTTPRequestTimeOut, Net::HTTPGatewayTimeOut
            return Response.new Net::ReadTimeout.new
          end
        end

        def direct_http_request
          Net::HTTP.start(*http_args) do |http|
            http.request(request)
          end
        end

        def proxy_http_request
          proxy.start(*http_args) do |http|
            http.request(request)
          end
        end

        def http_args
          return current_uri.host, current_uri.port, request_opts
        end

        def proxy
          Net::HTTP::Proxy(*proxy_address.to_a)
        end

        def http_get
          Net::HTTP::Get.new current_uri
        end

        def http_post
          Net::HTTP::Post.new current_uri
        end

        def use_ssl?
          current_uri.scheme == 'https'
        end

        def update_headers
          if proxy_address&.pw
            request.basic_auth(proxy_address.un, proxy_address.pw)
          end
        end

        def meta
          proxy_address ? { proxy: proxy_address&.to_s } : {}
        end
      end
    end
  end
end

