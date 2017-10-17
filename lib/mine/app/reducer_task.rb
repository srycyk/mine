
require 'mine/app/task_base'

module Mine
  module App
    class ReducerTask < TaskBase
      def call(name, predicate, list_values=nil, list_name=name, &block)
        visit_list = Storage::CycleListSave.get(name) do
          list_values or initial_values(list_name)
        end

        reducer = Scrape::Reducer.new(options)

        reducer.(visit_list, predicate, &block)
      end
    end
  end
end
