
#require 'net/http'

#require 'mine/fetch/http/base'
#require 'mine/fetch/http/response'

module Mine
  module Fetch
    module Http
      module FollowRedirect
        MAX_TRIES = 4

        def self.included(klass)
          klass.module_eval { attr_accessor :redirects, :max_tries }
        end

        def initialize(*)
          super

          self.redirects = []

          self.max_tries = MAX_TRIES
        end

        def redirecting?(response)
          if redirect? response
            redirect response

            true
          else
            false
          end
        end

        private

        def redirect(response)
          self.redirects.push url if redirects.none?

          location = response.http_response['location']

          self.redirects.push location

          self.url = location

          set_uri
        end

        def clear_redirects
          self.redirects = []
        end

        def redirect?(response)
          response.redirect? and redirect_below_limit?
        end

        def redirect_below_limit?
          redirects.size <= max_tries
        end
      end
    end
  end
end

