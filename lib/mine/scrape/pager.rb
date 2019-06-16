
require 'mine/scrape/traversal'
require 'mine/extract/extractor_helpers'

module Mine
  module Scrape
    class Pager < Traversal
      include Extract::ExtractorHelpers

      attr_accessor :visit_list, :finder

      # finder, block: -> (html_node) OR css selector string
      def call(list, finder=nil, &block)
        self.visit_list = list

        self.finder = finder || block

        return if finished?

        list_iterator.() do |url|
          response = process_request(url)

          visit_list.finish unless next_page(response.body)
        end
      end

      private

      def finished?
        if super
          return true unless next_page(last_item_html)
        end
        false
      end

      def next_page(html)
        if next_url = extract_next_url(html)
          visit_list.push! next_url
        end
      end

      def extract_next_url(html)
        if html and href = extract_next_href(html)
          Fetch::Http::BuildUri.absolute href, visit_list.first
        end
      end

      def extract_next_href(html)
        case finder
        when String
          parser(html).at_css(finder)&.attr('href')
        else
          parser(html, &finder)
        end
      end

      def last_item_html
        visit_list.data_item('html').(visit_list.size - 1)
      end
    end
  end
end
