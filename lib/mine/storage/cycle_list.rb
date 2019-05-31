
module Mine
  module Storage
    class CycleList < List
      attr_accessor :index

      def initialize(*)
        super

        reset
      end

      def reset(idx=0)
        self.index = idx

        self
      end

      def succ?
        index < items.size
      end

      def succ
        increment

        return unless succ?

        current
      end

      def current
        items[index]
      end

      def insert(object)
        items[index] = object
      end

      def remove
        items.delete_at index

        self.index = index - 1 if items.any? and index >= items.size
      end

      def to_s
        "#{position_info index + 1, items.size} [#{current}] <#{name}>"
      end
      def position_info(position, total)
        "#{position} of #{total} (#{(position * 100.0 / total).to_i}%)"
      end

      def increment(incremental=1)
        new_index = index + incremental

        self.index = new_index if new_index <= items.size

        self
      end

      def go_back
        increment(-1)
      end

      def find(item)
        reset
        begin
          return current if current == item
        end while succ
      end

      #
      def data_item?(ext=nil)
        data_item(ext).exists?
      end

      def data_item!(ext=nil)
        data_item(ext).()
      end

      def add_data_item(line, data, ext=nil)
        push! line

        data_item(ext).put(data)

        succ!
      end

      def data_item(ext=nil)
        ListDataItem.new(self, ext)
      end
      #
      private

    end
  end
end
