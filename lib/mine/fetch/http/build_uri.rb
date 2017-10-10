
require "mine/fetch/http/url_to_uri"

module Mine
  module Fetch
    module Http
      class BuildUri < Struct.new(:url)
        include UrlToUri

        TYPES = %i(params)

        attr_accessor :address

        def initialize(*)
          super

          self.address = uri
        end

        def call
          address
        end

        def to_s
          address.to_s
        end

        def params
          EscapeUri.new(address.query || {}).(:params)
        end

        def params=(other)
          self.address.query = EscapeUri.new(other).(:query)
        end

        def merge(other)
          self.params = params.merge(other)

          self
        end

        def delete(*names)
          self.params = params.delete_if {|key, _| names.include? key }

          self
        end

        def path
          address.path[1..-1]
        end

        def path=(other)
          address.path = absolute_path(other)
        end

        def replace(from, to='')
          self.path = path.sub(/#{from}/, to)

          self
        end

        def set(elements)
          elements.each {|name, value| address.send "#{name}=", value }

          self
        end

        def absolute(relative)
          relative_path, relative_query = relative.to_s.split '?'

          self.class.new(address.dup).set path: absolute_path(relative_path),
                                          query: relative_query
        end

        alias abs absolute

        class << self
          def absolute(url, original_url)
            if absolute? url
              url
            else
              new(original_url).absolute(url).to_s
            end
          end

          def absolute?(url)
            url =~ /^http/
          end
        end

        private

        def absolute_path(path)
          path.start_with?('/') ? path : '/' + path
        end
      end
    end
  end
end

