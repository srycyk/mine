require "test_helper"

describe Mine::Storage::ListDataItemIterator do
  let(:file_name) { 'list_data_item_iterator' }

  let(:items) { %w(one two three) }

  let :data_items do
    %w(First Second Third) #.map {|item| item + "\n" }
  end

  def list(items=[])
    Mine::Storage::CycleListSave.new items, file_name, 'test/lists'
  end

  def saved_list
    prepared_list = list 
    (0...data_items.size).each do |index|
      prepared_list.add_data_item items[index], data_items[index]
    end
    prepared_list.reset
  end

  def iterator(ignore_position=false, list=saved_list)
    Mine::Storage::ListDataItemIterator.new list, ignore_position
  end

  def delete_files
    dir = "tmp/ds-mine/test/lists/"

    files = [ file_name, "#{file_name}-index",
              "#{file_name}/0000", "#{file_name}/0001", "#{file_name}/0002" ]

    files.each do |file|
      path = "#{dir}#{file}.txt"

      File.unlink path if File.file? path
    end
  end

  def without_files
    delete_files
    yield
    delete_files
  end

  [ nil, true ].each do |ignore_position|
    position_status = "(#{ignore_position ? 'ignore' : 'keep'} position)"

    it "returns whole list w/o block #{position_status}" do
      without_files do
        assert_equal items, iterator(ignore_position, list(items)).()
      end
    end

    it "gets first #{position_status}" do
      without_files do
        iterator(ignore_position).('txt') do |data, item, index|
          assert_equal 'one', item
          assert_equal 'First', data.chomp

          break
        end
      end
    end

    it "gets last #{position_status}" do
      without_files do
        iterator(ignore_position).('txt') do |data, item, index|
          if index == 2
            assert_equal 'three', item
            assert_equal 'Third', data.chomp
          end
        end
      end
    end
  end
end
