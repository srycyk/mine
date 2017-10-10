
require 'mine/scrape/traversal'

module Mine
  module Scrape
    class Follower < Traversal
      def call(list)
        self.visit_list = list

        return if finished?

        list_iterator.() do |url|
          response = process_request(url)

          break if block_given? and yield(response, visit_list)
        end
      end
    end
  end
end
