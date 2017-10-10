
require 'mine/scrape/filter'

module Mine
  module Scrape
    class FilterGetEmails < Filter
      def call(response, input_list=nil)
        return if finished?

        search_emails response

        #search_contact_links response
      end

      def finished?
        super
      end

      private

      def search_emails(response)
        emails = email_search response.body

        if emails.any?
          #output_list.add_data_item response.uri.to_s, emails
        end
      end

      def email_search(html)
        EmailSearch.new(html).()
      end

      def search_contact_links(response)
        contacts = contact_link_search response.body, response.uri

        contacts.each do |contact_link|
          #response = agent.get
          #search_emails response
        end
      end

      def contact_link_search(html, uri)
        ContactLinkSearch.new(html, uri).()
      end
    end
  end
end
