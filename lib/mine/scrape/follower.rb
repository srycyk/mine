
require 'mine/scrape/traversal'

module Mine
  module Scrape
    class Follower < Traversal
      def call(list)
        self.visit_list = list

        return if finished?

        list_iterator.() {|url| process_request(url) }
      end
    end
  end
end
