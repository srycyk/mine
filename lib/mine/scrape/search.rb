
module Mine
  module Scrape
    class Search < Struct.new(:data, :item, :index)
      def call(data=nil, item=nil, index=nil)
        self.data = data if data
        self.item = item if item

        strip_utf8
      end

      private

      def strip_utf8
        self.data = data.scrub('?')
      end
    end
  end
end
