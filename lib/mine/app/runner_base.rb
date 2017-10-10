
require 'mine/app/task_utils'

module Mine
  module App
    class RunnerBase < Struct.new(:app_name, :config)
      include TaskUtils
      
      attr_accessor :settings, :xx

      def initialize(*)
        super

        self.settings = Settings.new(app_name || get_app_name)

        #self.xx = xx
      end

      def call(name)
        collect name

        extract name

=begin
        #filter =
        #reducer = ReducerTask.new settings, sleep_secs: 1
        #reducer.(sites_task_name, filter, sites)
=end
      end

      private

      def get_app_name
        self.class.name.split('::')[-2].downcase
      end
    end
  end
end
