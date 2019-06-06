
module Mine
  module Storage
    class ListDataItem < Struct.new(:list, :ext)
      #ZERO_PADDING = 4

      def call(index=nil)
        saver = storage index

        if saver.exists?
          saver.load
        end
      end

      def exists?(index=nil)
        storage(index).exists?
      end

      def sub_dir(index=nil)
        index = list.index unless index

        index_to_path.dir(index)
      end

      def file_name(index=nil)
        index = list.index unless index

        index_to_path.file(index)
      end

=begin
      def file_name(index=nil)
        index = list.index unless index

        ('0' * 9 + index.to_s)[-ZERO_PADDING..-1]
      end
=end

      def put(data, index=nil)
        saver = storage index

        saver.dump data
      end

      def remove
        saver.rm
      end

      private

      def storage(index=nil)
        Mine::Storage::DataSaver.new file_name(index), sub_dir: sub_dir(index),
                                                       ext: ext
      end

      def index_to_path
        #@index_to_path ||= IndexToPath.new(File.join list.sub_dir, list.name)
        @index_to_path ||= IndexToPath.new(list.name)
      end
    end
  end
end
