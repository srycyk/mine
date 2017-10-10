
require 'mine/scrape/traversal'

module Mine
  module Scrape
    class Pager < Traversal
      attr_accessor :visit_list

      def call(list, &block)
        self.visit_list = list

        return if finished?

        list_iterator.() do |url|
          response = process_request(url)

          next_url = Extract::Extractor.new(response&.body).(&block)&.first

          if next_url
            next_url = Fetch::Http::BuildUri.absolute next_url, list.first

            visit_list.push! next_url
          else
            visit_list.finish
          end
        end
      end

      private

      def extractor(*args, &block)
        Extract::Extractor.new(*args, &block)
      end
    end
  end
end
