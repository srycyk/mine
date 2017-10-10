
require 'mine/extract/parser'

module Mine
  module Extract
    class Extractor < Struct.new(:html, :output)
      attr_accessor :parser

      def initialize(*)
        super

        clear output

        self.parser = Parser.new(html)
      end

      def call(out=nil)
        clear out if out

        parser.() {|page| yield page, output }

        output
      end

      def clear(initial=nil)
        initial = [] unless initial

        self.output = initial
      end
    end
  end
end
