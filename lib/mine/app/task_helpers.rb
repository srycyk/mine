
require 'mine/concerns/reformatter'
require 'mine/concerns/sequence_list'

module Mine
  module App
    module TaskHelpers
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
    end
  end
end

