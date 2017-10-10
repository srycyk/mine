require "test_helper"

describe Mine::Storage::CycleList do
  let(:save_name) { :miner }

  let(:items) { %w(one two three four) }

  let(:list) { Mine::Storage::CycleList.new items, save_name }

  it 'starts at beginning' do
    assert_equal items.first, list.current
  end

  it 'gets second' do
    assert_equal items[1], list.succ
  end

  it 'succ starts at beginning if go_back' do
    assert_equal items.first, list.go_back.succ
  end

  it 'returns nothing at end' do
    (1..items.size-1).each { assert list.succ }

    refute list.succ
    refute list.succ?
  end

  it 'removes first item' do
    list.remove

    assert_equal 'two', list.current
    assert_equal 3, list.size
  end

  it 'removes second item' do
    list.succ
    list.remove

    assert_equal 'three', list.current
    assert_equal 3, list.size
  end

  it 'removes item at end' do
    (1...items.size).each { assert list.succ }
    list.remove

    assert_equal 'three', list.current
    assert_equal 3, list.size
  end

  it 'removes all' do
    (1..items.size).each { list.remove }
  end

  it 'inserts' do
    list.insert '1'

    assert_equal '1', list.current
  end
end
