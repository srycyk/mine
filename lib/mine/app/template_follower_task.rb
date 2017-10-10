
require 'mine/concerns/sequence_template'

module Mine
  module App
    class TemplateFollowerTask < FollowerTask
      attr_accessor :template_file_name

      def initialize(*args)
        if args.size > 1 and String === args.last
          self.template_file_name = args.pop
        end

        super *args
      end

      private

      def initial_values(name=nil)
        #Concerns::SequenceTemplate.new(name, template_file_name).()
        sequence_template(name, template_file_name).()
      end
    end
  end
end
