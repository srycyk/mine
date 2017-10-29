
require 'csv'

module Mine
  module App
    class Accumulator < Xref
      include Enumerable

      KEY_DELIM = '^'

      attr_accessor :sequence, :current_key

      def initialize(*)
        super

        self.sequence = '00000'
      end

      def get(key)
        super composite(key)
      end

      def add(key, *values)
        self.current_key = composite(key)

        super current_key, *values
      end

      def <<(value)
        dict[get_current_key] << value

        self
      end

      def +(values)
        dict[get_current_key] += [ values ].flatten

        self
      end

      def current
        dict[current_key]
      end

      #def assign(key_value_pairs)
      #  key_value_pairs.each_slice(2) do |(key, values)|
      #    add key, *[values].flatten
      #  end
      #end

      def each
        (dict.dict.keys.sort).each {|key| yield dict[key] }
      end

      def csv
        map &:to_csv
      end

      def write(path)
        File.open path, 'w' do |stream|
          stream.write csv.join
        end
      end

      private

      def get_current_key
        current_key or raise "No key present. Must first call #add"
      end

      def composite(key)
        to_key(key) * KEY_DELIM
      end

      def to_key(key)
        [ key ].flatten.map {|element| element or next_sequence }
      end

      def next_sequence
        sequence.succ!.dup
      end
    end
  end
end
