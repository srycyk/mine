
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

        contact_search = Scrape::ContactLinkSearch.new

        task App::FollowXrefTask do |follow_xref|
          follow_xref.(contact_search, site_list_name, name_suffix, options)
        end
=begin
        task App::FollowXrefTask, options do |follow_xref|
          follow_xref.(contact_search, site_list_name, name_suffix)
        end
=end
      end

      def email_xref_search(site_list_name, name_suffix=nil)
        name_suffix ||= XREF_SUFFIX

        email_search = Scrape::EmailSearch.new

        App::SearchAllXrefTask.new.(email_search, site_list_name, name_suffix)
      end

      def emails_by_site(site_list_name)
        @emails_by_site ||= begin
                              mails = email_xref_search site_list_name

                              reformatter(mails).array_mapper(0, 1)
                            end
      end
    end
  end
end

