
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
        follower_task(follower_options || options) do |follower|
          follower.(auxiliary_name(name, name_suffix), links)
        end
      end

      def link_list(searcher, name, name_suffix)
        index_links search_links(searcher, name), name, name_suffix
      end

      def index_links(links_by_site, name, name_suffix)
        link_xref = xref auxiliary_name(name, name_suffix)

        links = []

        links_by_site.each do |site_links, site|
          link_xref.add site, site_links

          links += site_links
        end

        link_xref.dump

        links
      end

      def search_links(searcher, name)
        SearchAllTask.new.(searcher, name)
      end

      def auxiliary_name(name, name_suffix)
        "#{name}-#{name_suffix}"
      end
    end
  end
end
