
require 'mine/app/task_base'

module Mine
  module App
    class FollowerTask < TaskBase
      def call(name, list_values=nil, &block)
        visit_list = Storage::CycleListSave.get(name) do
          list_values or initial_values(name)
        end

        follower = Scrape::Follower.new(options)

        issuer = follower.(visit_list, &block)
      end

      private

      def initial_values(name=nil)
        raise "Empty list: #{name}"
      end
    end
  end
end

