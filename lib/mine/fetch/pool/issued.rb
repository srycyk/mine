
require 'mine/concerns/dead_or_alive'

module Mine
  module Fetch
    module Pool
      class Issued
        include Concerns::DeadOrAlive

        DEFAULT_MAX_TRIES = 9

        attr_accessor :wrapped_object

        attr_accessor :max_tries, :num_tries

        def initialize(wrapped_object, max_tries=nil)
          super()

          self.wrapped_object = wrapped_object

          self.max_tries = max_tries || DEFAULT_MAX_TRIES

          self.num_tries = 0
        end

        def call
          if dead? 
            nil
          elsif hit_max_tries?
            die
          else
            self
          end
        end

=begin
        def each
          while alive?
            hit_max_tries? ? die : yield(self) #yield(wrapped_object)
          end

          self
        end
=end

        def to_s
          "#{wrapped_object} #{num_tries}/#{max_tries}"
        end

        def set_max(max=nil)
          self.max_tries = max unless max.nil?

          self
        end

        def respond_to?(name, *)
          super or wrapped_object&.respond_to? name #, :include_private
        end

        #private

        # Delegate calls to wrapped object
        def method_missing(name, *args)
          if wrapped_object.respond_to? name
            wrapped_object.send name, *args
          else
            super
          end
        end

        def increment_tries
          self.num_tries += 1
        end

        def hit_max_tries?
          increment_tries

          max_tries?
        end

        def max_tries?
          num_tries > (max_tries || 1)
        end
      end
    end
  end
end

