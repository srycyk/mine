
require 'mine/concerns/reformatter'

module Mine
  module App
    module TaskUtils
      CONFIG = 'config'

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
      def template(name, dirs=template_dirs, file_name=nil)
        Concerns::Template.new(name, dirs, file_name)
      end

      def sequence_template(name, dirs=template_dirs, file_name=nil)
        Concerns::SequenceTemplate.new(name, dirs, file_name)
      end

      def template_dirs
        [ join(pwd, CONFIG),
          join(settings.shallow_root_dir, CONFIG),
          join(settings.root_dir, CONFIG),
          join(CONFIG, settings.app_name) ]
      end

      def join(*dirs)
        File.join *dirs.flatten
      end

      def site_from_template
        template(nil).(%w(prefix))
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
    end
  end
end

