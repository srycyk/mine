
module Mine
  module App
    class SearchAllXrefTask < IterateAllBase
      include TaskHelpers

      def call(searcher, name, xref_name, *args)
        #xref_map = Xref.new(xref_name, name).()
        xref_map = xref(name).()

        xref_list_name = "#{name}-#{xref_name}"

        xref_list = Storage::CycleList.load xref_list_name

        super name, *args do |data, item, index|
          found = searcher.(data, item, index)

          if xref_items = xref_map.get(item)
            xref_items.each do |xref_item|
              xref_list.find xref_item

              xref_data = xref_list.data_item('html').()

              found += searcher.(xref_data, item, index)
            end
          end

          collector << [ found.sort.uniq, item, index ] if found&.any?
        end
      end
    end
  end
end

