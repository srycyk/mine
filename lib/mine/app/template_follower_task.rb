
require 'mine/concerns/sequence_template'

module Mine
  module App
    class TemplateFollowerTask < FollowerTask
      attr_accessor :proto_template
      attr_accessor :file_name, :paths

      def initialize(*args)
        self.proto_template = args.pop unless Hash === args.last

        super *args.compact
      end

      private

      def initial_values(name=nil)
        get_template(name).call
      end

      def get_template(name)
        case proto_template
        when :sequence, :seq, nil
          sequence_template(name, file_name, paths)
        when :template, :plain, true, false
          template(name, file_name, paths)
        when Array
          list_template(proto_template, name, file_name, paths)
        when Class
          proto_template.new name, file_name, paths
        else
          proto_template
        end
      end
    end
  end
end
