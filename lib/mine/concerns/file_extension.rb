
module Mine
  module Concerns
    class FileExtension < Struct.new(:dir)
      EXTENSIONS = %w(txt js json csv html htm jpeg jpg png gif)

      def call(name)
        files = []

        EXTENSIONS.each do |ext|
          file = "#{name}.#{ext}"

          path = File.join((*[dir].flatten), file)

          files << path if File.file? path

          yield ext, path, file if block_given?
        end

        files
      end
    end

    def first(name)
      call(name) {|ext| return ext }
    end
  end
end
