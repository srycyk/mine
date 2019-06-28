
module Mine
  module App
    module MailSearcher
      XREF_SUFFIX = 'aux'

      def xref_email_search(site_list_name, name_suffix=nil, options=nil)
        contact_page_xref(site_list_name, name_suffix, options)

        email_xref_search(site_list_name, name_suffix)
      end

      def contact_page_xref(site_list_name, name_suffix=nil, options=nil)
        name_suffix ||= XREF_SUFFIX

        task App::FollowXrefTask do |follow_xref|
          follow_xref.(contact_searcher, site_list_name, name_suffix, options)
        end
      end

      def email_xref_search(site_list_name, name_suffix=nil)
        name_suffix ||= XREF_SUFFIX

        App::SearchAllXrefTask.new.(email_searcher, site_list_name, name_suffix)
      end

      def emails_by_site(site_list_name)
        @emails_by_site ||= begin
                              mails = email_xref_search site_list_name

                              reformatter(mails).array_mapper(0, 1)
                            end
      end

      def email_search(site_list_name, name_suffix=nil)
        search_task(email_searcher, site_list_name)
      end

      def contact_searcher
        Scrape::ContactLinkSearch.new
      end

      def email_searcher
        Scrape::EmailSearch.new
      end
    end
  end
end

