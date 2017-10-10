
module Mine
  module Storage
    class ListDataItemIterator < ListIterator
      attr_accessor :ext

      def call(ext='html')
        self.ext = ext

        super()
      end

      def item_info(list, item)
        data = list.data_item(ext).()

        return data, item, list.index
      end
    end
  end
end
