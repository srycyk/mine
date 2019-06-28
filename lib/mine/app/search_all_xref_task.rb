
module Mine
  module App
    class SearchAllXrefTask < IterateAllBase
      include TaskHelpers

      def call(searcher, name, xref_name, output: nil, ext: 'html')
        xref_list_name = "#{name}-#{xref_name}"

        xref_map = xref(xref_list_name).()

        xref_list = Storage::CycleList.load xref_list_name

        super name, output: output do |data, item, index|
          found = searcher.(data, item, index)

          if xref_items = xref_map.get(item)
            xref_items.each do |xref_item|
              xref_list.find xref_item

              xref_data = xref_list.data_item(ext).()

              found += searcher.(xref_data, item, index)
            end
          end

          collector << [ found.sort.uniq, item, index ] if found&.any?
        end
      end
    end
  end
end

