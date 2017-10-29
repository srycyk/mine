
module Mine
  module Concerns
    class Alias < Struct.new(:name, :doubles)
      def initialize(*)
        super

        unless doubles
          self.doubles = read_doubles
        end
      end

      def call(equivalent)
        doubles[equivalent]
      end

      def to_s
        "#{name}: #{doubles.keys * ', '}\n"
      end

      private

      def read_doubles
        equivalents = read

        equivalents.zip([ name ] * equivalents.size).to_h
      end

      def read
        self.class.read_lines "config/aliases/#{name}.txt"
      end

      def self.read_lines(path)
        @read_lines ||= IO.read(path).split(/\r*\n+/)
      end
    end
  end
end

