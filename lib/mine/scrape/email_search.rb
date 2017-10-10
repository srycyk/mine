
module Mine
  module Scrape
    class EmailSearch < Search
      #MAIL_RE = /([^:@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i
      MAIL_RE = /[a-z0-9\.\-]+@(?:[-a-z0-9]+\.)+[a-z]{2,}/i

      IMAGE_EXT = %w(png jpg jpeg)

      def call(*)
        super

        mails = filter_okay by_href

        mails += filter_okay by_re

        mails.flatten.compact.map{|mail| strip_query mail }.sort.uniq
      end

      def by_href
        Mine::Extract::Parser.new(data).().css("a[href^='mail']").map do |m|
          strip_mailto m.attr('href')
        end
      end

      def by_re
        data.scan(MAIL_RE).to_a
      end

      private

      def strip_mailto(mail)
        mail.sub(/^(mailto|mail):/i, '')
      end

      def filter_okay(mails)
        mails.select {|mail| okay? mail }
      end

      def okay?(mail)
        MAIL_RE === mail and not mail.end_with?(*IMAGE_EXT)
      end

      def strip_query(mail)
        mail[0 .. ((mail.index('?') || 0 ) -1)]
      end
    end
  end
end
