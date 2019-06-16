
module Mine
  module Extract
    module ExtractorHelpers
      def attr_list_extractor(selector, attribute_name)
        -> page, out { page.css(selector).each do |tag|
                         out << tag.attr(attribute_name)
                       end }
      end

      def xref_attr_list_searcher(selector, name)
        -> html, base_url, index {
          parser(html).css(selector).reduce [] do |acca, tag|
            acca << tag[name]
          end
        }
      end

      def parser(html, &block)
        Parser.new(html).call(&block)
      end

      def extractor(*args, &block)
        extractor = Extractor.new(*args)

        block ? extractor.(&block) : extractor
      end
    end
  end
end

