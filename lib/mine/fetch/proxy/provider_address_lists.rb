
require 'mine/fetch/proxy/provider'

module Mine
  module Fetch
    module Proxy
      class ProviderAddressLists < Provider
        attr_accessor :addresses

        def initialize(name, *address_lists)
          super name

          address_list = address_lists.reduce(&:+)

          self.addresses = Storage::CycleList.new(address_list).go_back
        end

        private

        def fetch
          if line = addresses.succ
            return fetch if line =~ /^\s*$/ or line =~ /^\s*#/

            line
          else
            die or nil
          end
        end

        def values
          data&.split(/[\s:,]\s*/)&.map(&:strip)
        end
      end
    end
  end
end
