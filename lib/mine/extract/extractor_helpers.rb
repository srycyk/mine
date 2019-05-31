
module Mine
  module Extract
    module ExtractorHelpers
      def attr_list_extractor(selector, attribute_name)
        -> (page, out) { page.css(selector).each do |tag|
                           out << tag.attr(attribute_name)
                         end }
      end
    end
  end
end
