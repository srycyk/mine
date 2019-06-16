
require 'mine/concerns/template'
require 'mine/app/task_base'

module Mine
  module App
    class PagerTask < TaskBase
      # finder, block: -> (html_node) OR css selector string
      def call(name, start=nil, finder=nil, start_name: name, &block)
        visit_list = Storage::CycleListSave.get(name) do
          [ start || start_url(start_name) ]
        end

        pager = Scrape::Pager.new(options)

        pager.(visit_list, finder, &block)
      end

      def start_url(name)
        template(name).base
      end 
    end
  end
end

