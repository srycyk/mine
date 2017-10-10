
require "mine/fetch/http/agent_base"
require 'mine/fetch/http/follow_redirect'
require 'mine/fetch/http/headers'

module Mine
  module Fetch
    module Http
      class Agent < AgentBase
        include FollowRedirect

        def call
          @request = nil

          headers = update_headers

          http_response = http_request

          response = Response.new http_response, meta

          response.dump_cookie

          if get? and redirecting? response
            call
          else
            response.http_request_headers = headers

            response
          end
        end

        private

        def request_opts(timeout=15)
          { use_ssl: use_ssl?,
            open_timeout: timeout,
            read_timeout: timeout,
            ssl_timeout: timeout }
        end

        def request
          @request ||= get? ? get_request : post_request
        end

        def get_request
          if params?
            self.current_uri = BuildUri.new(current_uri).merge(params).()
          end

          http_get
        end

        def post_request
          post = http_post

          if params?
            post_params = EscapeUri.new params

            if attributes[:unipart]
              post.set_form_data post_params.(:params)
            else
              post.content_type = 'multipart/form-data'

              post.body = post_params.()
            end
          end

          post
        end

        def update_headers
          super

          Headers.new(request).()
        end

        def http_method
          attributes&.fetch(:method, nil) or (params? ? 'POST' : 'GET')
        end

        def get?
          http_method == 'GET'
        end

        def params
          params? and attributes[:params]
        end
        def params?
          attributes&.has_key?(:params)
        end

        def meta
          { method: http_method,
            url: url,
            uri: current_uri,
            http_headers: request.to_hash.to_s,
            redirects: redirects,
            attributes: attributes }
          .merge(super)
        end
      end
    end
  end
end

