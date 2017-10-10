
module Mine
  module Storage
    class ListDataItem < Struct.new(:list, :ext)
      ZERO_PADDING = 4

      def call(index=nil)
        saver = storage index

        if saver.exists?
          saver.load
        end
      end

      def sub_dir
        return list.sub_dir, list.name
      end

      def exists?(index=nil)
        storage(index).exists?
      end

      def file_name(index=nil)
        index = list.index unless index

        ('0' * 9 + index.to_s)[-ZERO_PADDING..-1]
      end

      def put(data, index=nil)
        saver = storage index

        saver.dump data
      end

      def remove
        saver.rm
      end

      private

      def storage(index=nil)
        Mine::Storage::DataSaver.new file_name(index), sub_dir: sub_dir,
                                                       ext: ext
      end
    end
  end
end
