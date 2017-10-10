
module Mine
  module Concerns
    class SequenceList < Struct.new(:template_string, :list)
      def initialize(*)
        super
      end

      def call
        if list&.any?
          list.map {|item| template_string % item }
        else
          [ template_string % '' ]
        end
      end
    end
  end
end
