
require 'mine/concerns/dead_or_alive'

module Mine
  module Fetch
    module Pool
      class IssuerLog < Struct.new(:factory_recycler)
        ERRORS = %i(dead_factory dead_issuer invalid_issue
                    provider_error ran_out)

        attr_accessor :counts, :errors, :consecutive_errors, :items

        def initialize(*)
          super

          self.counts = Hash.new(0)

          self.errors = {}
          ERRORS.each {|key| self.errors[key] = Hash.new(0) }

          self.consecutive_errors = Hash.new(0)

          self.items = {}
        end

        def consecutive_count
          consecutive_errors[get_key]
        end

        def to_s
          out = ''

          out << "Counts: #{counts}\n"
          out << "Errors: #{errors}\n"
          out << "Consecutive_errors: #{consecutive_errors}\n"
          out << "Items: #{items}\n"
          out << "Factory_recycler: #{factory_recycler.inspect}\n"
          out << "#{issued_total} issued"
        end

        def issued
          self.counts[get_key] += 1

          self.consecutive_errors[get_key] = 0
        end

        def error(name)
          self.errors[name][get_key] += 1

          self.consecutive_errors[get_key] += 1

          nil
        end

        def item(item)
          self.items[get_key] ||= []

          self.items[get_key] << item.to_s
        end

        def issued_total
          counts.values.reduce &:+
        end

        def get_key
          current = factory_recycler.current

          current_name = current.name if current.respond_to? :name

          current_name or factory_recycler.index
        end
      end
    end
  end
end
