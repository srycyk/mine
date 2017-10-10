
module Mine
  module Concerns
    module DeadOrAlive
      def self.included(klass)
        klass.module_eval { attr_accessor :alive }
      end

      def initialize(*)
        super

        self.alive = true
      end

      def dead?
       not alive?
      end
      def alive?
        alive
      end

      def die
        self.alive = false
      end
    end
  end
end
