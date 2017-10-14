
module Mine
  module App
    class SearchAllTask < IterateAllBase
      def call(searcher, *args)
        super *args do |data, item, index|
          found = searcher.(data, item, index)

          collector << [ found, item, index ] if found&.any?

          collector
        end
      end
    end
  end
end

