
require 'mine/concerns/sequence_template'

module Mine
  module App
    class TemplateFollowerTask < FollowerTask
      attr_accessor :template_name, :template_dirs

      def initialize(*args)
        self.template_dirs = args.pop if Array === args.last
        self.template_name = args.pop if String === args.last

        super *args.compact
      end

      private

      def initial_values(name=nil)
        sequence_template(name, template_name, template_dirs).()
      end
    end
  end
end
