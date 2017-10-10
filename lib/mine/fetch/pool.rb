
require 'mine/fetch/pool/issued'
require 'mine/fetch/pool/issuer'
require 'mine/fetch/pool/issued_supplier'

module Mine
  module Fetch
    module Pool
      def self.call(providers=Proxy::ProviderFactory.(), tries=nil)
        Fetch::Pool::IssuedSupplier.new providers, tries
      end
    end
  end
end

