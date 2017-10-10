
#require 'mine/scrape/traversal_options'

module Mine
  TerminationError = Class.new StandardError

  NoMoreProxiesError = Class.new TerminationError
  TooManyAttemptsError = Class.new TerminationError

  module Scrape
    class Traversal
      attr_accessor :options

      attr_accessor :visit_list

      attr_accessor :proxy_issuer

      def initialize(options)
        self.options = options

        set_proxy_issuer options.proxy_providers, options.proxy_tries
      end

      def set_proxy_issuer(providers, tries=nil)
        if providers&.any?
          self.proxy_issuer = Fetch::Pool::IssuedSupplier.new providers, tries
        end

        self
      end

      def set_log_to(log_to)
        options.set_log_to log_to

        self
      end

      def get_page(url, proxy=nil)
        agent(url, proxy).()
      end

      def save_page(response, out_list=nil)
        list_data_item = (out_list || visit_list).data_item 'html'

        response.saver(list_data_item.sub_dir).(list_data_item.file_name)
      end

      private

      def process_request(url, tries=1)
        begin
          process_request!(url)
        rescue TerminationError => e
          log e

          raise e
        rescue => e
          if (tries += 1) <= options.retries
            sleep options.retries_pause

            retry
          else
            log e

            if options.remove_on_error?
              log "  Removing: #{visit_list}\n"

              visit_list.remove!.go_back

              Class.new{ def body() '' end }.new # Stub blank response
            else
              raise TooManyAttemptsError, visit_list.to_s
            end
          end
        end
      end

      def process_request!(url)
        proxy = get_proxy

        log ">> #{visit_list} (#{proxy})\n"

        response = get_page url, proxy

        if response.success?
          on_success response

          sleep options.pause
        else
          raise StandardError, "Failure: #{self} - #{proxy}\n#{response.info}"
        end

        response
      end

      def finished?
        visit_list.resume.finished?
      end

      def get_proxy
        if proxy_issuer
          proxy_issuer.() or raise NoMoreProxiesError, "#{visit_list}"
        end
      end

      def on_success(response)
        save_page response
      end

      def agent(url, proxy=nil)
        Fetch::Http::Agent.new(url, proxy: proxy)
      end

      def list_iterator
        Storage::ListIterator.new visit_list
      end

      def to_s
        "#{options} #{visit_list}"
      end

      def log(message)
        options.log_to << message.to_s if options.log_to
      end
    end
  end
end
