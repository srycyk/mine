
require 'mine/app/task_utils'

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

      def to_s
        "#{options} #{inspect} "
      end
=begin
      def initialize(*args, **opts)
        super *args

        self.options = opts
      end

      def proxy_args
        settings.proxy_args options[:proxy], options[:tries]
      end

      def sleep_secs
        options[:sleep_secs] or options[:proxy] && 5
      end

      # TODO with agent_args
      def keep_cookie
        options[:keep_cookie]
      end
=end
    end
  end
end
