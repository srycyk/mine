
require "uri"
require 'net/http'

module Mine
  module Fetch
    module Http
      class Response < Struct.new(:http_response, :meta)
        attr_accessor :http_request_headers

        def body
          http_response.body
        end

        alias to_s body

        def info
          ResponseInfo.new self, meta #[:attributes]
        end

        def saver(sub_dir=nil, deep_base: nil)
          ResponseSaver.new self, sub_dir, deep_base
        end

        def dump_cookie
          Headers.store_cookie uri.host, http_response.to_hash
        end

        def success?
          response_code == :success
        end

        def redirect?
          response_code == :redirect
        end

        def read_csrf_token
          if http_response.body.size > 100
            meta_tag = Extract::Parser.new(http_response.body).()
              .css("meta[name='csrf-token']")

            meta_tag.attribute('content').to_s if meta_tag&.any?
          end
        end

        def uri
          http_response.uri
        end

        def response_code
          case http_response
          when Net::HTTPOK, Net::HTTPSuccess
            :success
          when Net::HTTPRedirection, Net::HTTPMovedPermanently
            :redirect
          when Net::HTTPNotFound
            :failure
          when Net::ReadTimeout, Net::OpenTimeout,
               Net::HTTPRequestTimeOut, Net::HTTPGatewayTimeOut
            # Throws exception
            :timeout
          when Net::HTTPForbidden
            :forbidden
          when Errno::ECONNRESET, Net::HTTPBadResponse,
               Net::HTTPInternalServerError, Net::HTTPServiceUnavailable,
               Net::HTTPGatewayTimeOut, Net::HTTPBadGateway
            :failure
          else
            :unknown
          end
        end
      end
    end
  end
end

