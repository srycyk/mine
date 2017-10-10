
require 'mine/concerns/dead_or_alive'
require 'mine/fetch/pool/issuer_log'

module Mine
  module Fetch
    module Pool
      class IssuedSupplier < Struct.new(:factories, :tries)
        include Concerns::DeadOrAlive

        attr_accessor :issuer, :issued

        def initialize(*)
          super

          self.issuer = Issuer.new factories, tries
        end

        def reset
          @issuer, @issued = []

          self
        end

        def call
          if issued
            if self.issued = issued.()
              issued
            else
              next_issued
            end
          else
            next_issued
          end
        end

        def next_issued
          self.issued = issuer.()&.()
        end
=begin
        include Enumerable

        def each(*args)
          self.issuer = Issuer.new *args

          while self.issued = issuer.()
            yield issued, issuer
          end

          issuer
        end
=end
      end
    end
  end
end
