
module Mine
  module Scrape
    class LinkSearch < Search
      attr_accessor :search_terms

      def call(*)
        super

        filter_links.compact.sort.uniq
      end

      def filter_links
        links = []
        Mine::Extract::Parser.new(data).().css("a").each do |a|
          href = a.attr('href')

          next unless href

          href = href[0, href.index('#') || 999]

          next if href.empty? or mail?(href) or href.start_with? '..'

          text = a.text

          if has_search_term?(href) or has_search_term?(text)
            links << (item ? to_absolute(href) : href)
          end
        end
        links
      end

      def has_search_term?(text)
        search_terms.each {|name| return true if text =~ /#{name}/i }

        false
      end

      private

      def to_absolute(link)
        Fetch::Http::BuildUri.absolute link, item rescue link
      end

      def mail?(href)
        href =~ /(mail|mailto):/
      end

    end
  end
end
