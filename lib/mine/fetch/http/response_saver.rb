
require "uri"
require 'net/http'

require "mine/concerns/take_time"

module Mine
  module Fetch
    module Http
      class ResponseSaver < Struct.new(:response, :sub_dir, :deep_base)
        EXTENSIONS = %w(png gif jpeg jpg pdf js json css text txt)

        def call(name=nil, with_time: name.nil?, deep_base: nil)
          self.deep_base = deep_base if deep_base

          name = "_#{take_time.hour}#{name && '-'}#{name}" if with_time

          dump_data name

          dump_meta_data name
        end

        def dump_data(name)
          store(name, ext).dump response.body
        end

        def dump_meta_data(name)
          store(name, 'info').dump response.info.to_s
        end

        private

        def store(name, extension=nil)
          Storage::DataSaver.new name, sub_dir: sub_dir,
                                       ext: extension,
                                       deep_base: deep_base
        end

        def sub_dir
          super or [ 'log', take_time.date ]
        end

        def take_time
          @take_time ||= Concerns::TakeTime.new
        end

        def ext
          search_ext or 'html'
        end
        def search_ext
          site = response.uri.to_s

          EXTENSIONS.each {|ext| return ext if site.end_with? ext }

          nil
        end
      end
    end
  end
end

