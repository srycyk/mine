
module Mine
  module App
    class SearchAllXrefTask < IterateAllBase
      def call(searcher, name, xref_name, *args)
        xref = Xref.new(xref_name, name).()

        aux_list_name = "#{name}-#{xref_name}"

        aux_list = Storage::CycleList.load aux_list_name

        super name, *args do |data, item, index|
          found = searcher.(data, item, index)

          if items = xref.get(item)
            items.each do |aux_item|
              aux_list.find aux_item

              aux_data = aux_list.data_item('html').()

              found += searcher.(aux_data, item, index)
            end
          end

          collector << [ found.sort.uniq, item, index ] if found&.any?
        end
      end
    end
  end
end

