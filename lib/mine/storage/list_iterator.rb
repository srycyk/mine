
module Mine
  module Storage
    class ListIterator < Struct.new(:list_or_name, :ignore_position, :ext)
      def call
        items = []

        list = get_list

        item = first_value(list)

        while item
          items << item

          yield *item_info(list, item) if block_given?

          item = next_value(list)
        end

        items
      end

      def item_info(list, item)
        return item
      end

      def first_value(list)
        list.resume if not ignore_position and list.respond_to?(:resume)

        list.current
      end

      def next_value(list)
        if not ignore_position and list.respond_to?(:succ!)
          list.succ!
        else
          list.succ
        end
      end

      private

      def get_list
        case list_or_name
        when String, Symbol
          default_list
        else
          list_or_name
        end
      end

      def default_list
        if ignore_position
          Storage::CycleList.get(list_or_name)
        else
          Storage::CycleListSave.get(list_or_name)
        end
      end
    end
  end
end
