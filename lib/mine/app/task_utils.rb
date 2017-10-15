
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

      def template_follower_task(options=nil, template_paths=nil,
                                 template_file=nil,  &block)
        task TemplateFollowerTask, options, template_paths,
                                   template_file, &block
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
=begin
      # Tasks
      def task(klass, options={})
        klass.new(settings, options).tap {|task| yield task if block_given? }
      end

      def follower_task(options=nil, &block)
        options = overt unless options

        task FollowerTask, options, &block
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
        Scrape::TraversalOptions.new **opts
      end

      # Working dir
      def under(*args, &block)
        Storage.under *args, &block
      end

      def pwd
        Storage::DataLocator.root
      end

      # Templates
      TEMPLATE_CONFIG = 'config'

      def template(name, dirs=nil, file_name=nil)
        dirs ||= default_template_paths

        Concerns::Template.new(name, dirs, file_name)
      end

      def sequence_template(name, dirs=nil, file_name=nil)
        dirs ||= default_template_paths

        Concerns::SequenceTemplate.new(name, dirs, file_name)
      end

      def list_template(items, name=nil, dirs=nil, file_name=nil)
        template_string = template(name, items, dirs, file_name).()

        Mine::Concerns::SequenceList.new(template_string, items)
      end

      def default_template_paths
        [ join(pwd, TEMPLATE_CONFIG),
          join(settings.shallow_root_dir, TEMPLATE_CONFIG),
          join(settings.root_dir, TEMPLATE_CONFIG),
          join(TEMPLATE_CONFIG, settings.app_name) ]
      end

      def join(*dirs)
        File.join *dirs.flatten
      end

      def site_from_template(elements=%w(prefix))
        template(nil).(elements)
      end

      # Url's
      #def add_domain(url, domain)
      #  url.sub %r{//}, "//#{domain}."
      #end

      def expand_links(links, base_url)
        links.map {|link| Fetch::Http::BuildUri.absolute link, base_url }
      end

      # Collections
      def reformatter(container)
        Concerns::Reformatter.new(container)
      end

      def accumulator(name: 'acca', load_up: true)
        acca = Accumulator.new(name)

        load_up ? acca.() : acca
      end

      # Strings
      def stage_name(name, type)
        "#{name}-#{type}"
      end

      def trim(string)
        (string || '').sub(/\\t/, ' ').strip.squeeze(' ')
      end

      def strip_tags(text)
        text.gsub(%r{</?[^>]+?>}, '')
      end

      def app_token(name)
        "#{settings.app_name}-#{name}"
      end
=end
    end
  end
end

