
require 'mine/concerns/sequence_template'

module Mine
  module App
    class TemplateFollowerTask < FollowerTask
      attr_accessor :template_paths, :template_file

      def initialize(*args)
        self.template_file = args.pop if String === args.last
        self.template_paths = args.pop if Array === args.last

        super *args
      end

      private

      def initial_values(name=nil)
puts sequence_template(name, template_paths, template_file) #.()
        sequence_template(name, template_paths, template_file).()
      end
    end
  end
end
