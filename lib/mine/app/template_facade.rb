
require 'mine/concerns/reformatter'
require 'mine/concerns/sequence_list'

module Mine
  module App
    module TemplateFacade
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
    end
  end
end

