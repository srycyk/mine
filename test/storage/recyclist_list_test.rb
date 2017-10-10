require "test_helper"

describe Mine::Storage::RecycleList do
  let(:save_name) { :miner }

  let(:items) { %w(one two three four) }

  let(:list) { Mine::Storage::RecycleList.new items, save_name }

  it 'starts at beginning' do
    assert_equal items.first, list.succ
  end

  it 'gets second' do
    list.succ
    assert_equal items[1], list.succ
  end

  it 'goes back to beginning' do
    (1..items.size).each { list.succ }

    assert_equal items.first, list.succ
  end
end
