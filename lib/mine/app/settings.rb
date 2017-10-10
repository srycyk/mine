
require 'nokogiri'

module Mine
  module App
    class Settings < Struct.new(:app_name, :config)
      DIR_BASE = 'apps'

      def initialize(*)
        super

        raise "No app_name" unless app_name

        locator_class.app_root = [ DIR_BASE, app_name.to_s ]

        self.config ||= {}

        locator_class.absolute_root = config[:root] if config&.key? :root
      end

      def root_dir
        locator_class.app_root
      end
      def shallow_root_dir
        locator_class.shallow_root
      end
      def deep_root_dir
        locator_class.deep_root
      end

      #def logging_on?
      #  ENV['LOGOFF'] ? false : true
      #end

      def proxy_providers
        #addresses = [ '110.216.61.8 80', "89.36.212.124 1189" ]
        #address_list = Fetch::Proxy::ProviderAddressLists.new('list', addresses)
        #self.providers = [ address_list ]
        providers = Fetch::Proxy::ProviderFactory.call.shuffle
      end

      def proxy_args(on=false, num_tries=nil)
        if on
          return proxy_providers, num_tries
        end
	[]
      end

      private

      def locator_class
        Storage::DataLocator
      end
    end
  end
end
