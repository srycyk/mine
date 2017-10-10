
module Mine
  module Fetch
    module Proxy
      class Address < Struct.new(:addr, :port, :un, :pw)
        attr_accessor :name

        def to_a
          super.compact
        end

        def to_s(long=false)
          to_a * ' ' + (long && name ? " <#{name}>" : '')
        end

        def set_name(name)
          self.name = name

          self
        end

        def port
          super or '80'
        end

        def valid?
          addr and addr =~ %r([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)
        end
      end
    end
  end
end
