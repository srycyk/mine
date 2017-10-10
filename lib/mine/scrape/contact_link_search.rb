
module Mine
  module Scrape
    class ContactLinkSearch < LinkSearch
      private

      def search_terms
        [ 'contact', 'about', 'in touch' ]
      end
    end
  end
end
