
require 'mine/app/task_base'

module Mine
  module App
    class FollowXrefTask < TaskBase
      def call(searcher, name, name_suffix='aux', options=nil)
        xref = Xref.new(name_suffix, name)

        links_by_site = SearchAllTask.new.(searcher, name)

        link_list = []

        links_by_site.each do |links, site|
          xref.add site, links

          link_list += links
        end

        xref.dump

        aux_file = "#{name}-#{name_suffix}"

        follower_task(options) {|follower| follower.(aux_file, link_list) }
      end

      private

      def initial_values(name=nil)
        raise "Empty list: #{name}"
      end
    end
  end
end
