
module Mine
  module Fetch
    module Proxy
      class ProviderFactory #< Struct.new(:name)
        NAMES = %i(gimmeproxy proxicity getproxylist pubproxy byteproxies)

        #attr_accessor :available_providers

        def call(name=nil)
          #raise ran_out_error unless available_providers?

          #self.name = as_name(id)

          case name
          when :gimmeproxy
            Providers::Gimmeproxy.new name
          when :proxicity
            Providers::Proxicity.new name
          when :getproxylist
            Providers::Getproxylist.new name
          when :pubproxy
            Providers::Pubproxy.new name
          when :byteproxies
            Providers::Byteproxies.new name
          else
            call :byteproxies
          end
        end

=begin
        def available_providers?
          available_names and available_names.any?
        end

        def available_names
          self.available_providers ||= NAMES
        end

        def add(id, first: false)
          array_method = first ? :unshift : :push

          self.available_providers = available_providers
                                     .send(array_method, as_name(id))
        end

        def remove(id)
          self.available_providers = available_providers.delete as_name id
        end

        # Rotates through providers
        def self.call
          count = 0

          -> { new.call(count).tap { count += 1 } }
        end
=end
        def self.call(*args)
          NAMES.map {|name| new.(name, *args) }
        end

        private

=begin
        def default_name
          available_names.first
        end

        def as_name(id)
          case id
          when Integer
            index = id % available_names.size

            available_names[index]
          when String, Symbol
            id.to_sym
          else
            NAMES.first
          end
        end

        def ran_out_error
          "No proxies left from: #{NAMES * ' '}"
        end
=end
      end
    end
  end
end
