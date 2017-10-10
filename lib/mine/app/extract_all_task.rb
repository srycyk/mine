
require 'mine/app/iterate_all_base'

module Mine
  module App
    class ExtractAllTask < IterateAllBase
      def call(*, &block)
        super do |data, item, index|
          Extract::Extractor.new(data, collector).(&block)
        end
      end

      def text_at(node, selector)
        node.at_css(selector)&.text
      end
    end
  end
end

