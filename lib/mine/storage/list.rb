
module Mine
  module Storage
    class List
      FORWARDING_METHODS = %i(length size first last any? none? + << [] []=)

      include Enumerable

      attr_accessor :items, :name, :sub_dir

      def initialize(items, name=nil, sub_dir=nil)
        self.items = items

        self.name = name || 'xxxx'

        self.sub_dir = sub_dir
      end

      def dump
        storage.dump to_string(items)

        self
      end

      def rm
        storage.rm
      end

      def load
        self.items = to_array(storage.load)

        self
      end

      class << self
        def load(*args)
          list = new nil, *args

          list.load
        end

        def get(*args)
          list = new nil, *args

          if list.exists?
            list.load
          else
            list.items = block_given? ? yield : []

            list.dump
          end
        end
      end

      def path
        storage.path
      end

      def exists?
        storage.exists?
      end

      def push(*more_items)
        items.push *more_items
      end

      # Forward Array-like calls to the array in self.items
      def each(*args, &block)
        items.each(*args, &block)
      end

      def ==(other)
        items == other.to_a #(List === other ? other.items : other.to_a)
      end

      FORWARDING_METHODS.each do |name|
        define_method(name) {|*args| items.send name, *args }
      end

      private

      def storage
        Mine::Storage::DataSaver.new name, sub_dir: sub_dir
      end

      def to_string(data)
        case data
        when Array, self.class
          data.map(&:to_s).map(&:chomp) * EOL + EOL
        else
          data
        end
      end

      def to_array(data)
        case data
        when String
          data.split EOL
        else
          data
        end
      end
    end
  end
end
