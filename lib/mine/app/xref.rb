
module Mine
  module App
    class Xref
      attr_accessor :name, :sub_dir

      attr_accessor :dict

      def initialize(name=nil, sub_dir=nil)
        self.name = name
        self.sub_dir = sub_dir

        self.dict = Storage::Dict.new(name: name, sub_dir: sub_dir)
      end

      def call
        dict.()

        self
      end

      def get(key)
        dict[key]
      end

      def add(key, *values)
        current = get(key) || []

        dict[key] = current + values.flatten.compact
      end

      def dump
        dict.dump
      end

      def to_s
        dict.hash.inspect
      end

      private
    end
  end
end
