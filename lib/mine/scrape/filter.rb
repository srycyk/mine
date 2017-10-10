
#require 'mine/scrape/traversal'

module Mine
  module Scrape
    class Filter < Struct.new(:output_list)
      attr_accessor :opaque

      def call(response, input_list=nil)
        return if finished?
      end

      def finished?
        false
      end

      private

    end
  end
end
