
require 'mine/app/task_base'

module Mine
  module App
    class FollowerTask < TaskBase
      def call(name, list_values=nil, list_name: name, &block)
        visit_list = Storage::CycleListSave.get(name) do
          list_values or block ? block.(name) : initial_values(list_name)
        end

        follower = Scrape::Follower.new(options)

        issuer = follower.(visit_list, &block)
      end
    end
  end
end

