
module Mine
  module Concerns
    class Reformatter < Struct.new(:container)
      def initialize(*)
        super
      end

      def array_mapper(value_index=1, key_index=0)
        array_plucker(key_index, value_index).to_h
      end

      def array_plucker(*indexes)
        container.map {|items| items.values_at *indexes }
      end
    end
  end
end

