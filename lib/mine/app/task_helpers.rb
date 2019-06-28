
require 'mine/concerns/reformatter'
require 'mine/concerns/sequence_list'
require 'mine/app/template_facade'

module Mine
  module App
    module TaskHelpers
      include TemplateFacade

      # Working dir
      def under(*args, &block)
        Storage.under *args, &block
      end

      def pwd
        Storage::DataLocator.root
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

      def pluck(array_list, *indexes)
        reformatter(array_list).array_plucker(*indexes)
      end

      def normalise(list)
        list.compact!.sort!.uniq
      end

      def accumulator(name: 'acca', load_up: true)
        acca = Accumulator.new(name)

        load_up ? acca.() : acca
      end

      def xref(name, sub_dir: nil)
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
        (name ? name + '-' : '') + 'aux'
      end

      def xref_name(name)
        "#{name}-xref"
      end
    end
  end
end

