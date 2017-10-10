
require 'mine/concerns/config_file'

module Mine
  module Concerns
    class Template < Struct.new(:name, :sub_dirs, :file_name)
      ELEMENTS = %w(prefix infix suffix)

      attr_accessor :params, :named_params

      def initialize(*)
        super

        self.file_name ||= 'template'

        #self.params = dict(file_name, sub_dir).()
        self.params = config_file.()

        self.named_params = params[name] || {}
      end

      def call(wanted_elements=nil)
        (wanted_elements || elements).reduce '' do |acc, element_name|
          acc << element(element_name)
        end
      end

      private

      def element(element_name)
        named_params[element_name.to_s] or named_params[element_name.to_sym] or
          params[element_name]
      end

      def config_file
        ConfigFile.new file_name, sub_dirs
      end

      #def dict(file_name, sub_dir)
      #  Storage::Dict.new name: file_name, sub_dir: sub_dir || 'config'
      #end

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
