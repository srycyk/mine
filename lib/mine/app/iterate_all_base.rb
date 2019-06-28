
module Mine
  module App
    class IterateAllBase < Struct.new(:settings)
      attr_accessor :collector

      def initialize(*)
        super

        self.collector = []
      end

      def call(name, output: nil, ext: nil, &block)
        self.collector = output if output

        list_iterator = Storage::ListDataItemIterator.new(name, true, ext)

        list_iterator.(&block)

        collector
      end
    end
  end
end

