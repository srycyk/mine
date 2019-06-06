
require 'mine/storage/data_locator'
require 'mine/storage/data_saver'

require 'mine/storage/list'
require 'mine/storage/cycle_list'
require 'mine/storage/cycle_list_save'
require 'mine/storage/recycle_list'

require 'mine/storage/dict'

require 'mine/storage/list_data_item'
require 'mine/storage/list_iterator'
require 'mine/storage/list_data_item_iterator'

require 'mine/storage/index_to_path'

module Mine
  module Storage
    def self.under(*args, &block)
      DataLocator.under *args, &block
    end
  end
end
