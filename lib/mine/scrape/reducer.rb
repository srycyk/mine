
require 'mine/scrape/traversal'

module Mine
  module Scrape
    class Reducer < Traversal
      attr_accessor :predicate

      # predicate: -> (html, list)
      def call(list, predicate)
        self.visit_list = list

        return if finished?

        self.predicate = predicate

        list_iterator.() do |url|
          response = process_request(url)
        end
      end

      private

      def on_success(response)
        if predicate.(response.body, visit_list)
          save_page response
        else
          visit_list.remove!.go_back
        end
      end
    end
  end
end
