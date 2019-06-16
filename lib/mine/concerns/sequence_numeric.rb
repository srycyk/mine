
module Mine
  module Concerns
    class SequenceNumeric < Struct.new(:template_string, :limit,
                                       :multiple, :start)
      def initialize(*)
        super
      end

      def call
        if count.to_i > 0
          ((start || 1)..limit).map do |count|
            template_string % (count * (multiple || 1))
          end
        else
          [ template_string % '' ]
        end
      end
    end
  end
end
