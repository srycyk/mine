
require "uri"
require 'net/http'

module Mine
  module Fetch
    module Http
      class ResponseInfo < Struct.new(:response, :attributes)
        def to_s
          out = "#{uri} #{}"

          out << EOL << "#{reply} <HTTP #{http_response.http_version}>"

          out << EOL << EOL << Time.now.to_s
          out << EOL << http_response.class.name
          out << EOL << response.response_code.to_s

          out << EOL << EOL << "Request Attributes" << EOL
          #show_atts response.attributes, out: out, indent: '- '
          show_atts attributes, out: out, indent: '- '

          if csrf_token = response.csrf_token
            out << EOL << "CSRF-Token = '#{csrf_token}'" << EOL
          end

          if response.http_request_headers
            out << EOL << EOL << "Request Headers" << EOL
            show_atts response.http_request_headers, out: out, indent: '> '
          end

          out << EOL << EOL << "Response Headers" << EOL
          show_atts http_response.to_hash, out: out, indent: '< '

          out << EOL
        end

        private

        def http_response
          response.http_response
        end

        def uri
          response.uri #or response.attributes[:url]
        end

        def reply
          "#{http_response.code} #{http_response.message}"
        end

        def show_atts(atts, out: '', indent: '')
          return out unless atts

          atts.reduce out do |acc, (name, value)|
            acc << "#{indent}#{name}: #{show_value value}#{EOL}"
          end
        end
        def show_value(value)
          case value
          when Array
            value * ', '
          when Hash
            value.to_json
          else
            value
          end
        end
      end
    end
  end
end

