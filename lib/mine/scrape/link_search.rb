
module Mine
  module Scrape
    class LinkSearch < Search
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

          link_text = a.text

          if has_search_terms?(href, link_text) and include_term?(href)
            links << (item ? to_absolute(href) : href)
          end
        end
        links
      end

      def has_search_terms?(*text_list)
        text_list.each {|text| return true if has_search_term?(text) }
        false
      end

      def has_search_term?(text)
        has_term?(text, search_terms)
      end

      def include_term?(text)
        not has_term?(text, exclude_terms)
      end

      private

      # Override
      def search_terms
        []
      end
      def exclude_terms
        []
      end

      def has_term?(text, terms)
        terms.each {|term| return true if text =~ /#{term}/i }
        false
      end

      def to_absolute(link)
        Fetch::Http::BuildUri.absolute link, item rescue link
      end

      def mail?(href)
        href =~ /(mail|mailto):/
      end

    end
  end
end
