
module Mine
  module Storage
    class ListDataItemIterator < ListIterator
      def call(extension=nil)
        self.ext = extension || ext || 'html'

        super()
      end

      def item_info(list, item)
        data = list.data_item(ext).()

        return data, item, list.index
      end
    end
  end
end

