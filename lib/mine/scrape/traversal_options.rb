
module Mine
  module Scrape
    OPTION_NAMES = %i(proxy_providers proxy_tries pause log_to
                      retries retries_pause failure_retries
                      remove_on_error agent_options)

    class TraversalOptions < Struct.new(:proxy_providers, :proxy_tries,
                                        :pause, :log_to,
                                        :retries, :retries_pause,
                                        :failure_retries,
                                        :remove_on_error,
                                        :agent_options)
      SLEEP_SECS = 1

      def initialize(proxy_providers: nil, proxy_tries: nil,
                     pause: nil, log_to: nil,
                     retries: nil, retries_pause: nil,
                     failure_retries: nil,
                     remove_on_error: nil,
                     agent_options: nil)
        set_proxy_providers proxy_providers
        set_proxy_tries proxy_tries

        set_pause pause

        set_remove_on_error remove_on_error

        set_log_to log_to

        set_retries retries
        set_retries_pause retries_pause

        set_failure_retries failure_retries

        set_agent_options agent_options
      end

      def set_pause(secs=nil)
        self.pause = secs || pause || SLEEP_SECS

        self
      end

      def set_log_to(output=nil)
        self.log_to = output || (output == false ? nil : STDOUT)

        self
      end

      def set_retries(retries=nil)
        self.retries = retries || 8

        self
      end
      def set_retries_pause(retries_pause=nil)
        self.retries_pause = retries_pause || 10

        self
      end

      def set_failure_retries(failure_retries=nil)
        self.failure_retries = failure_retries || 5

        self
      end

      def set_agent_options(opts=nil)
        self.agent_options = (agent_options || {}).merge(opts || {})

        self
      end

      def set_proxy_providers(providers=nil)
        self.proxy_providers = providers

        self
      end
      def set_proxy_tries(tries=nil)
        self.proxy_tries = tries

        self
      end

      def set_remove_on_error(remove=nil)
        self.remove_on_error = remove ? true : false

        self
      end
      alias remove_on_error? remove_on_error

      def to_s
        members.inject('') {|acca, name| acca << show(name) }
      end

      def self.clean_options(options)
        options.select {|key, _| OPTION_NAMES.include? key }
      end

      private

      def show(name)
        "#{name}(#{self[name]}) "
      end
    end
  end
end
