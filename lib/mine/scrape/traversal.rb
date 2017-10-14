
#require 'mine/scrape/traversal_options'

module Mine
  TerminationError = Class.new StandardError

  NoMoreProxiesError = Class.new TerminationError
  TooManyAttemptsError = Class.new TerminationError

  module Scrape
    class Traversal
      PROXY_GIVE_UP_TRIES = 4

      attr_accessor :options

      attr_accessor :visit_list

      attr_accessor :proxy_issuer

      attr_accessor :failure_count

      def initialize(options)
        self.options = options

        set_proxy_issuer options.proxy_providers, options.proxy_tries

        self.failure_count = 0
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

      def process_request(url, tries=1, error_count=0)
        begin
          proxy = get_proxy error_count

          return process_request!(url, proxy)
        rescue TerminationError => e
          log e

          raise e
        rescue => e
          if (tries += 1) <= options.retries
            sleep options.retries_pause

            error_count += 1

            retry
          else
            log e

            if options.remove_on_error?
              log "  Removing: #{visit_list}\n"

              visit_list.remove!.go_back

              return blank_response
            else
              if (self.failure_count += 1) > options.failure_retries
                raise TooManyAttemptsError, visit_list.to_s
              end

              issue_proxy&.die

              wait_for = failure_count * 60 * 1
              log "  Too many attempts - waiting for #{wait_for / 60} mins\n"
              sleep wait_for

              remove_cookie url

              #return process_request url

              tries, error_count = 0, 0

              retry
            end
          end
        end
      end

      def process_request!(url, proxy=nil)
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

      def get_proxy(error_count)
        if proxy_issuer
          issue_proxy.die if error_count > PROXY_GIVE_UP_TRIES

          issue_proxy
        end
      end
      def issue_proxy
        proxy_issuer.() or raise NoMoreProxiesError, "#{visit_list}"
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

      def blank_response
        Class.new{ def body() '' end }.new
      end

      def remove_cookie(url)
        uri = URI === url ? url : URI.parse(url)

        Fetch::Http::Headers.delete_cookie uri.host
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
