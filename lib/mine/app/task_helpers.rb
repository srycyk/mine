
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
      TEMPLATE_CONFIG_DIR = 'config'

      def template(name, file_name=nil, paths=nil)
        file_name ||= template_file
        paths ||= template_paths

        Concerns::Template.new(name, file_name, paths)
      end

      def sequence_template(name, file_name=nil, paths=nil)
        file_name ||= template_file
        paths ||= template_paths

        Concerns::SequenceTemplate.new(name, file_name, paths)
      end

      def list_template(items, name=nil, file_name=nil, paths=nil)
        template_string = template(name, file_name, paths).()

        Mine::Concerns::SequenceList.new(template_string, items)
      end

      def template_paths
        [ join(pwd, TEMPLATE_CONFIG_DIR),
          join(settings.shallow_root_dir, TEMPLATE_CONFIG_DIR),
          join(settings.root_dir, TEMPLATE_CONFIG_DIR),
          join(TEMPLATE_CONFIG_DIR, settings.app_name) ]
      end

      def template_file
        # default: 'template'
      end

      def join(*dirs)
        File.join *dirs.flatten
      end

      def site_from_template(elements=%w(prefix))
        template(nil).(elements)
      end

      # Nokogiri

      def parser(html)
      end

      # Url's
      #def add_domain(url, domain)
      #  url.sub %r{//}, "//#{domain}."
      #end

      def expand_links(links, base_url)
        links.map {|link| expand_link(link, base_url) }
         .compact
      end

      def expand_link(link, base_url)
        Fetch::Http::BuildUri.absolute(link, base_url) rescue nil
      end

      # Collections
      def reformatter(container)
        Concerns::Reformatter.new(container)
      end

      def normalise(list)
        list.compact!.sort!.uniq
      end

      def accumulator(name: 'acca', load_up: true)
        acca = Accumulator.new(name)

        load_up ? acca.() : acca
      end

      # Xref
      def xref(name, sub_dir=nil)
        Xref.new(xref_name(name), sub_dir)
      end

      # Strings
      def trim(string)
        (string || '').sub(/\\t/, ' ').strip.squeeze(' ')
      end

      def strip_tags(text)
        text.gsub(%r{</?[^>]+?>}, '')
      end

      # Names
      def stage_name(name, type)
        "#{name}-#{type}"
      end

      def app_token(name)
        "#{settings.app_name}-#{name}"
      end

      def aux(name=nil)
        "#{name ? name + '-' : ''}aux"
      end

      def xref_name(name)
        "#{aux name}-xref"
      end
    end
  end
end

