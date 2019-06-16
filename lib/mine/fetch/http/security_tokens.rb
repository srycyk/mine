
require "uri"
require 'net/http'

module Mine
  module Fetch
    module Http
      class SecurityTokens < Struct.new(:html)
        def csrf_token
          if html.size > 100
            meta_tag = parser.at_css("meta[name='csrf-token']")

            meta_tag&.attr('content')
          end
        end
        alias csrf csrf_token

        def authenticity_token
          if html.size > 100
            selector = "input[name='authenticity_token']"

            parser.at_css(selector)&.attr('value')
          end
        end
        alias auth authenticity_token

        private

        def parser
          Mine::Extract::Parser.new(html).()
        end
      end
    end
  end
end

