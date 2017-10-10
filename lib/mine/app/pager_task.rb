
require 'mine/concerns/template'
require 'mine/app/task_base'

module Mine
  module App
    class PagerTask < TaskBase
      def call(name, start=nil, &block)
        visit_list = Storage::CycleListSave.get(name) do
          [ start || start_url(name) ]
        end

        pager = Scrape::Pager.new(options)

        pager.(visit_list, &block)
      end

      def start_url(name)
        template(name).()
      end 
    end
  end
end
