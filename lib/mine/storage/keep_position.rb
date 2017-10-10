
module Mine
  module Storage
    module KeepPosition
      def initialize(*)
        super
      end

      def start(new_position=0)
        self.index = new_position.to_i

        pause
      end

      def pause
        position_saver.dump index.to_s

        self
      end

      def play
        self.index = position

        self
      end

      def resume
        if started?
          play
        else
          start
        end

        self
      end

      def position
        position_saver.load.to_i
      end

      def rm
        super

        clear_position
      end

      def clear_position
        position_saver.rm if started?

        self
      end

      def started?
        position_saver.exists?
      end

      def finish
        start items.size
      end

      def finished?(reload=false)
        load if reload

        started? and position.to_i >= items.size
      end

      private

      def position_saver
        DataSaver.new position_file_name, sub_dir: sub_dir
      end

      def position_file_name
        "#{name}-index"
      end
    end
  end
end
