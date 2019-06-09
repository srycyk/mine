
require 'json'

module Mine
  module Concerns
    class ConfigFile
      attr_accessor :name, :dirs, :ext, :accumulate

      def initialize(name, dirs, ext: 'json', accumulate: false)
        self.name = name
        self.dirs = dirs
        self.ext = ext
        self.accumulate = accumulate
      end

      def call
        if accumulate?
          search.reverse.reduce({}) {|acca, dir| acca.merge read dir } 
        else
          read search.first
        end
      end

      def search
        dirs.select {|dir| File.file? path(dir) }
      end

      def accumulate?
        accumulate
      end

      def read(dir)
        return {} unless dir

        JSON.parse IO.read path dir
      end

      def path(dir)
        File.join dir, file
      end

      def file
        "#{name}.#{ext}"
      end
=begin
      def stringify_all_keys(hash)
        stringified_hash = {}
        hash.each do |k, v|
          stringified_hash[k.to_s] = v.is_a?(Hash) ? stringify_all_keys(v) : v
        end
        stringified_hash
      end
=end
    end
  end
end

