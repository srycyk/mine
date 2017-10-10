
require 'nokogiri'

module Mine
  module Extract
    class Parser < Struct.new(:html, :attributes)
      def initialize(*)
        super

        self.attributes ||= {}
      end

      def call
        if block_given?
          yield parser
        else
          parser
        end
      end

      def parser
        @parser ||= Nokogiri::HTML html
      end
    end
  end
end
