
module Mine
  module Storage
    class RecycleList < CycleList
      def initialize(*)
        super

        self.index = -1
      end

      def succ
        super or reset.current
      end
    end
  end
end
