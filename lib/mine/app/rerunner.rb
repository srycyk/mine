

module Mine
  module App
    class Rerunner < RunnerBase
      attr_accessor :retries, :interval

      def initialize(*)
        super

        self.retries = 3

        self.interval = 5
      end

      def call(*args, &block)
        recover { yield super }
      end

      def recover(tries=0)
        begin
          yield
        rescue => e
          if (tries += 1) <= retries
            sleep interval

            redo
          else
            raise e
          end
        end
      end

      private

    end
  end
end
