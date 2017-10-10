
module Mine
  module Storage
    class DataLocator < Struct.new(:sub_dir, :extension, :deep_base)
      DEFAULT_ROOT = 'ds-mine'

      def call(name, ext: nil, item: nil)
        self.extension = get_extension ext

        item ? elements(name)[item] : elements(name)
      end

      #def sub_dir_suffix(sub)
      #  self.sub_dir << sub
      #  self
      #end

      def elements(name)
        { path: path(name), file: file(name), ext: extension,
          dir: dir, dirs: dirs,
          root: self.class.root,
          deep_root: self.class.deep_root,
          shallow_root: self.class.shallow_root }
      end

      class << self
        attr_accessor :absolute_root, :app_root, :app_branch

        def root
          [ shallow_root, app_branch ].compact.flatten
        end

        def shallow_root
          [ deep_root, app_root ].compact.flatten
        end

        def deep_root
          ENV['MINE_ROOT_DIR'] or absolute_root or
              default_root or [ "tmp", DEFAULT_ROOT ]
        end

        def default_root
          File.directory? DEFAULT_ROOT and DEFAULT_ROOT
        end

        def under(*dirs)
          self.app_branch ||= []

          app_branch.push dirs

          yield root, dirs

          app_branch.pop
        end
      end

      private

      def roots
        #[ deep_root, shallow_root, root ]
      end

      def path(name)
        File.join dir, file(name)
      end

      def file(name)
        "#{name}.#{extension}"
      end

      def dir
        File.join *dirs
      end

      def get_extension(ext=nil)
        ext or extension or 'txt'
      end

      def dirs
        [ (deep_base && self.class.shallow_root) || self.class.root, sub_dir ]
          .flatten.compact.map(&:to_s)
      end
    end
  end
end
