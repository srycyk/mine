
module Mine
  module Concerns
    module FileExtension < Struct(:dir)
      EXTENSIONS = %w(txt json csv html)

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
  end
end
