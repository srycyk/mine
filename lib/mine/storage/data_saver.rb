
require 'fileutils'
require 'json'
require 'csv'

module Mine
  module Storage
    # options:
    #   sub_dir:   leaf directory (under a branch) of the file
    #   ext:       file extension, txt (default)
    #   mode:      load data as string (default) or as lines
    #   deep_base: use the application base dir, not the working dir (default)
    class DataSaver < Struct.new(:name, :options)
      def initialize(*)
        super

        self.options ||= {}
      end

      def dump(data, open_op='w')
        mkdirs

        self.options[:ext] ||= 'json' if Hash === data
        self.options[:ext] ||= 'csv' if list_of_lists? data

        File.open path, open_op.to_s do |stream|
          stream.write as_string data
        end
      end

      def load(mode=nil)
        mode ||= :json if options[:ext] == 'json'
        mode ||= :csv if options[:ext] == 'csv'
        mode ||= :rb if options[:ext] == 'rb'

        case mode || options[:mode] || :string
        when :string, :as_string
          load_string
        when :lines, :as_lines
          load_lines
        when :json, :as_json
          self.options[:ext] ||= 'json'

          load_json
        when :csv, :as_csv
          self.options[:ext] ||= 'csv'

          load_csv
        when :rb, :as_rb, :ruby, :as_ruby
          self.options[:ext] ||= 'rb'

          eval load_string
        end
      end

      def rm
        File.unlink path if exists?
      end

      def exists?
        File.file? path
      end

      def load_lines
        IO.readlines(path).map &:chomp
      end

      def load_string
        IO.read path
      end

      def load_json
        JSON.parse load_string
      end

      def load_csv
        CSV.parse load_string
      end

      def path
        locator[:path]
      end

      private

      def dir
        locator[:dir]
      end

      def locator
        DataLocator.new(*options.values_at(:sub_dir, :ext, :deep_base)).(name)
      end

      def mkdirs
        FileUtils.mkdir_p(dir) if not Dir.exists?(dir)
      end

      def as_string(data)
        case data
        when Array
          if list_of_lists? data
            data.map(&:to_csv).map(&:chomp) * EOL + EOL
          else
            data.map(&:chomp) * EOL + EOL
          end
        when Hash
          data.to_json
        else
          data.to_s.chomp + EOL
        end
      end

      def list_of_lists?(candidate)
        list? candidate and list? candidate.first
      end
      def list?(candidate)
        candidate and Array === candidate
      end
    end
  end
end
