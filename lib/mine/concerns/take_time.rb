
module Mine
  module Concerns
    class TakeTime
      def call
        [ date, hour ]
      end

      def date
        at_present.strftime "%F"
      end

      def hour
        at_present.strftime "%H_%M_%S"
      end

      private

      def at_present
        @at_present ||= Time.now
      end
    end
  end
end
