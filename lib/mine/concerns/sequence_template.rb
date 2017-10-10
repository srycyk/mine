
require 'mine/concerns/template'
require 'mine/concerns/sequence_numeric'

module Mine
  module Concerns
    class SequenceTemplate < Template
      def call(*)
        sequence super, element('count'), element('multiple'), element('start')
      end

      private

      def sequence(template_string, count, multiple=nil, start=nil)
        SequenceNumeric.new(template_string, count || 0, multiple, start).()
      end
    end
  end
end
