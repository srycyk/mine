
require 'mine/concerns/reformatter'
require 'mine/concerns/sequence_list'

module Mine
  module App
    module TaskUtils
      def task(klass, options=nil, *args)
        options = overt unless options

        klass.new(settings, options, *args).tap {|task| yield task if block_given? }
      end

      def follower_task(options=nil, &block)
        task FollowerTask, options, &block
      end

      def pager_task(options=nil, &block)
        task PagerTask, options, &block
      end

      def reducer_task(options=nil, &block)
        task ReducerTask, options, &block
      end

      def template_follower_task(options=nil, paths=nil, file_name=nil, &block)
        task TemplateFollowerTask, options, paths, file_name, &block
      end

      def follow_xref_task(searcher, name, name_suffix, options=nil)
        task FollowerXrefTask options do |follow_xref|
          follow_xref.(searcher, name, name_suffix)
        end
      end

      def search_xref_task(searcher, name, name_suffix)
        SearchAllXrefTask.new.(searcher, name, name_suffix)
      end

      def extract_task(name, &extractor)
        ExtractAllTask.new(settings).(name, &extractor)
      end

      def search_task(name, &searcher)
        SearchAllTask.new(settings).(name, &searcher)
      end

      # Options
      def covert(override={})
        providers = settings.proxy_providers

        traversal_options **proxy_options(providers).merge(override)
      end

      def overt(override={})
        traversal_options **default_options.merge(override)
      end

      def casual(override={})
        traversal_options **removal_options.merge(override)
      end

      def default_options
        { pause: 1, retries: 3 }
      end
      def proxy_options(providers)
        { proxy_providers: providers, proxy_tries: 12, pause: 9 }
      end
      def removal_options
        { remove_on_error: true, pause: 1, retries: 3, retries_pause: 10 }
      end

      def traversal_options(**opts)
        #opts = Scrape::TraversalOptions.clean_options opts

        Scrape::TraversalOptions.new **opts
      end
    end
  end
end

