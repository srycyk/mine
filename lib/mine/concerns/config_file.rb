
require 'json'

module Mine
  module Concerns
    class ConfigFile
      EXTENSIONS = %w(json rb)

      attr_accessor :name, :dirs, :exts, :accumulate
      alias accumulate? accumulate

      def initialize(name, dirs, extensions: nil, accumulate: false)
        self.name = name
        self.dirs = dirs
        self.exts = extensions || EXTENSIONS
        self.accumulate = accumulate
      end

      def call
        if accumulate?
          search.reverse.reduce({}) {|acca, path| acca.merge read path } 
        else
          read search.first
        end
      end

      alias to_h call

      private

      def search
        dirs.reduce [] do |acca, dir|
          exts.each {|ext| add_if_present(dir, ext, to: acca) }

          acca
        end
      end

      def add_if_present(dir, ext, to:)
        path = File.join(dir, "#{name}.#{ext}")

        to << path if File.file? path
      end

      def read(path)
        return {} unless path

        contents = IO.read path

        case path
        when /\.json/
          JSON.parse contents
        when /\.rb/
          stringify_keys eval(contents)
        else
          contents
        end or Hash.new
      end

      def stringify_keys(hash)
        stringified = {}

        hash.each do |key, value|
          stringified[key.to_s] = Hash === value ? stringify_keys(value) : value
        end if hash

        stringified
      end
    end
  end
end

