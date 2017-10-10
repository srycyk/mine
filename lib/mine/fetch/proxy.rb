
require 'mine/fetch/proxy/address'

require 'mine/fetch/proxy/provider_factory'
require 'mine/fetch/proxy/provider_address_lists'

require 'mine/fetch/proxy/providers'

module Mine
  module Fetch
    module Proxy
      def self.call(name=nil)
        ProviderFactory.new.(name)
      end
    end
  end
end
