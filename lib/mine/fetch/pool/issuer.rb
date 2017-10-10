
require 'mine/concerns/dead_or_alive'
require 'mine/fetch/pool/issuer_log'

module Mine
  module Fetch
    module Pool
      class Issuer < Struct.new(:factories, :tries)
        MAX_PROVIDER_ERRORS = 10

        include Concerns::DeadOrAlive

        attr_accessor :factory_recycler, :log

        def initialize(*)
          super

          self.factory_recycler =
               Storage::RecycleList.new factories.dup, 'issuer'

          self.log = IssuerLog.new factory_recycler
        end

        def call
          die unless factory_recycler.any?

          if dead?
            log.error :dead_issuer
          elsif provider_factory = factory_recycler.succ
            if provider_factory.dead?
              log.error :dead_factory

              remove

              return call
            elsif current_issue = provider_factory.()
              if current_issue.respond_to?(:valid?) ? current_issue.valid? : true
                log.issued
                log.item current_issue

                return Issued.new current_issue, tries
              else
                log.error :invalid_issue

                provider_factory.die if too_many_errors?

                return call
              end
            else
              log.error :provider_error

              provider_factory.die if too_many_errors?

              return call
            end
          else
            log.error :ran_out
          end
        end

        def remove
          factory_recycler.current.die

          factory_recycler.remove
        end

        def to_s
          factory_names = factories&.map(&:name) || []

          "#{factories&.size} factories: (#{factory_names * ', '})\n#{log}"
        end

        private

        def too_many_errors?
          log.consecutive_count >= MAX_PROVIDER_ERRORS
        end
      end
    end
  end
end
