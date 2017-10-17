
require 'mine/app/task_utils'
require 'mine/app/task_helpers'

module Mine
  module App
    # options:
    #   proxy: false
    #   tries: nil
    #   sleep_secs: nil
    #   keep_cookie: false
    #   agent_options: {} # TODO
    class TaskBase < Struct.new(:settings, :options)
      include TaskUtils
      include TaskHelpers

      def initial_values(name=nil)
        raise "Empty list: #{name}"
      end

      def to_s
        "#{options} #{inspect} "
      end

=begin
      # TODO with agent_args
      def keep_cookie
        options[:keep_cookie]
      end
=end
    end
  end
end
