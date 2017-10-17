
require 'mine/app/template_location_cl'

module Mine
  module App
    class RunnerBaseCL < RunnerBase
      def initialize(*)
        super

        TaskBase.prepend TemplateLocationCL
      end

      include TemplateLocationCL

      private

    end
  end
end
