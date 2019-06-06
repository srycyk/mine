require "test_helper"

describe Mine::Storage::CycleListSave do
  let(:save_name) { :miner }

  let(:items) { %w(one two three four five) }

  let(:list) { Mine::Storage::CycleListSave.new items, save_name, 'test/lists' }

  def advance(times=1)
    list.start

    (1..times).each { list.succ }

    list
  end

  after { list.rm }

  it 'starts' do
    list.start 1

    assert_equal'two', list.current
  end

  it 'pauses' do
    advance(2).pause.reset

    assert 2, list.position
  end

  it 'plays' do
    advance.pause.reset

    assert 2, list.play.position
  end

  it 'finishes at last item' do
    (1..items.size-1).each { list.succ! }

    refute list.finished?
    assert_equal items.last, list.current
  end

  it 'finishes' do
    (1..items.size).each { list.succ! }

    assert list.finished?
    refute list.current
  end

  it 'adds item to end' do
    list.push 'door'
    assert_equal 6, list.size
  end
end
