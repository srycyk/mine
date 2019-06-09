
module Mine
  module Scrape
    class ContactLinkSearch < LinkSearch
      private

      def search_terms
        [ 'contact', 'about', 'in touch', 'company', 'enquiry' ]
      end

      def exclude_terms
        %w(google linkedin)
      end
    end
  end
end
