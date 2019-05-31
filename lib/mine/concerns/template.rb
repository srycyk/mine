
require 'mine/concerns/config_file'

module Mine
  module Concerns
    class Template < Struct.new(:name, :file_name, :sub_dirs)
      ELEMENTS = %w(prefix infix suffix)

      attr_accessor :params, :named_params

      def initialize(*)
        super

        self.file_name ||= 'template'

        self.params = config_file.()

        self.named_params = params[name] || {}
      end

      def call(wanted_elements=nil)
        (wanted_elements || elements).reduce '' do |acc, element_name|
          acc << element(element_name)
        end
      end

      def element(element_name=params.keys.first)
        named_params[element_name.to_s] or named_params[element_name.to_sym] or
          params[element_name.to_s] or params[element_name.to_sym]
      end

      alias base element

      private

      def config_file
        ConfigFile.new file_name, sub_dirs
      end

      def elements
        ELEMENTS
      end

      def self.show(app_name, name)
        Storage::DataLocator.app_root = File.join('apps', app_name)

        template = new name, nil, 'config'

        template.().tap { Storage::DataLocator.app_root = nil }
      end
    end
  end
end
