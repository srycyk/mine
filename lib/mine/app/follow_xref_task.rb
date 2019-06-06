
require 'mine/app/task_base'

module Mine
  module App
    class FollowXrefTask < TaskBase
      def call(searcher, name, name_suffix=nil, follower_options=nil)
        name_suffix ||= 'aux'

        links = link_list(searcher, name, name_suffix)

        follow_links links, name, name_suffix, follower_options
      end

      private

      def follow_links(links, name, name_suffix, follower_options)
        auxiliary_file = "#{name}-#{name_suffix}"

        follower_task(follower_options || options) do |follower|
          follower.(auxiliary_file, links)
        end
      end

      def link_list(searcher, name, name_suffix)
        index_links search_links(searcher, name), name, name_suffix
      end

      def index_links(links_by_site, name, name_suffix)
        #xref = Xref.new(name_suffix, name)
        xref = xref(name)

        link_list = []

        links_by_site.each do |links, site|
          xref.add site, links

          link_list += links
        end

        xref.dump

        link_list
      end

      def search_links(searcher, name)
        SearchAllTask.new.(searcher, name)
      end
    end
  end
end
