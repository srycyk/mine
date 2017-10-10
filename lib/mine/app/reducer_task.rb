
require 'mine/app/task_base'

module Mine
  module App
    class ReducerTask < TaskBase
      def call(name, predicate, list_values=nil, &block)
        visit_list = Storage::CycleListSave.get(name) do
          list_values or initial_values(name)
        end

        reducer = Scrape::Reducer.new(options)

        reducer.(visit_list, predicate, &block)
      end

      private

      def initial_values(name=nil)
        raise "Empty list: #{name}"
      end
    end
  end
end
