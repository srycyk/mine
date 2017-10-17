
require 'mine/concerns/sequence_template'

module Mine
  module App
    class TemplateFollowerTask < FollowerTask
      attr_accessor :template_dirs, :template_name

      def initialize(*args)
        self.template_name = args.pop if String === args.last
        self.template_dirs = args.pop if Array === args.last

        super *args.compact
      end

      private

      def initial_values(name=nil)
        sequence_template(name, template_dirs, template_name).()
      end
    end
  end
end
