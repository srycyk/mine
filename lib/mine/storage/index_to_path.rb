
module Mine
  module Storage
    class IndexToPath
      DIR_SIZE, FILE_SIZE = 2, 3

      DIVISOR = 10 ** FILE_SIZE

      attr_accessor :ext, :sub_dir, :ext, :mkdir

      def initialize(sub_dir=nil, ext=nil, mkdir=nil)
        self.sub_dir = Symbol === sub_dir ? sub_dir.to_s : sub_dir

        self.ext = Symbol === ext ? ext.to_s : ext

        self.mkdir = mkdir.nil? ? true : mkdir
      end

      def call(index)
        #dir = directory(index)

        #mkdir_if_needed(dir)

        File.join dir(index), file(index)
      end

      def dir(index)
        dir = pad(index.to_i / DIVISOR, DIR_SIZE)

        sub_dir ? File.join(sub_dir, dir) : dir
      end

      def file(index)
        filename(index) + extension
      end

      private

      def mkdir_if_needed(dir)
        FileUtils.mkdir_p(dir) if mkdir and not Dir.exists?(dir)
      end

      def filename(index)
        pad(index.to_i % DIVISOR, FILE_SIZE)
      end

      def extension
        ext ? ".#{ext}" : ''
      end

      def pad(index, length)
        index.to_s.rjust length, '0'
      end
    end
  end
end
