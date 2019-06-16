
require 'mine/app/task_facade'
require 'mine/app/task_helpers'

module Mine
  module App
    module TemplateLocationCL
      #private

      def template_paths
        [ 'config', './' ]
      end

      def template_file
        settings.app_name
      end
    end
  end
end
