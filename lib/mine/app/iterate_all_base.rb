
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

        clean
      end

      def clean
        self.collector = collector.compact.sort.uniq
      end
    end
  end
end
