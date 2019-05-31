
require 'mine/app/task_utils'
require 'mine/app/task_helpers'

module Mine
  module App
    class RunnerBase < Struct.new(:app_name, :config)
      include TaskUtils
      include TaskHelpers
      
      attr_accessor :settings

      def initialize(*)
        super

        self.app_name ||= get_app_name

        self.settings = Settings.new(app_name)
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
        #self.class.name.split('::')[-2].downcase
        elements = self.class.name.split('::').reverse

        if first = elements.shift
          name = first.sub /Runner$/, ''

          if name == ''
            elements.shift
          else
            name
          end
        else
          'default'
        end.downcase
      end
    end
  end
end
