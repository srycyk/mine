
require 'mine/extract/extractor'
require 'mine/extract/extractor_helpers'

module Mine
  module Extract
    def self.call(*args)
      Extractor.new *args
    end
  end
end
