
module Mine
  module App
    class IterateAllBase < Struct.new(:settings)
      attr_accessor :collector

      def initialize(*)
        super

        self.collector = []
      end

      def call(name, out=nil, &block)
        self.collector = out if out

        list_iterator = Storage::ListDataItemIterator.new(name, true)

        list_iterator.(&block)

        collector
      end
    end
  end
end

