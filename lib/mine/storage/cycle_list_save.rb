
require 'mine/storage/keep_position'

module Mine
  module Storage
    class CycleListSave < CycleList
      include KeepPosition

      def succ!
        succ.tap { pause }
      end

      def push!(*more_items)
        if more_items.any?
          push *more_items

          # TODO open file with append 'a'
          dump
        end

        self
      end

      def remove!
        remove

        dump
      end

      def rm
        #reset
        #while succ
        #  data_item(ext).remove
        #end
        #Dir.delete File.join(path, name)

        super
      end
    end
  end
end
