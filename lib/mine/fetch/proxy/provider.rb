
require 'json'

require 'mine/concerns/dead_or_alive'

module Mine
  module Fetch
    module Proxy
      class Provider < Struct.new(:name)
        include Concerns::DeadOrAlive

        attr_accessor :response

        def call
          self.response = fetch

          to_address values if address_okay?
        end

        private

        def to_address(address_list)
          Address.new(*address_list).set_name(name)
        end

        def data
          response
        end

        def address_okay?
          values&.any?
        end

        def parse_json(string)
          JSON.parse string
        end
      end
    end
  end
end
