
require 'mine/extract/extractor'

module Mine
  module Extract
    def self.call(*args)
      Extractor.new *args
    end
  end
end
