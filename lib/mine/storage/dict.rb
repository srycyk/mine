
module Mine
  module Storage
    class Dict
      attr_accessor :storage, :dict

      def initialize(sub_dir: nil, name: 'config', ext: 'json', deep_base: nil)
        self.storage = DataSaver.new name, ext: ext,
                                           sub_dir: sub_dir,
                                           deep_base: deep_base
        self.dict = {}
      end

      def call
        self.dict = storage.load if storage.exists?

        self
      end

      def [](key)
        dict[key.to_s]
      end

      def []=(key, value)
        dict[key.to_s] = value
      end

      def dump
        storage.dump dict
      end

      # TODO forward 'hash' calls
    end
  end
end
