
require 'mine/app/task_base'

module Mine
  module App
    class ReducerTask < TaskBase
      # predicate: -> (html, list)
      def call(name, predicate, list_values=nil, list_name: name, &block)
        visit_list = Storage::CycleListSave.get(name) do
          list_values or block ? block.(name) : initial_values(list_name)
        end

        reducer = Scrape::Reducer.new(options)

        reducer.(visit_list, predicate)
      end
    end
  end
end
