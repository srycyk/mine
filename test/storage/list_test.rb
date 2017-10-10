require "test_helper"

describe Mine::Storage::List do
  let(:file_name) { 'list' }

  let(:items) { %w(hi ho off we go) }

  let(:list_class) { Mine::Storage::List }

  let(:list) { list_class.new items, file_name, 'test' }

  def delete_list_file
    path = "tmp/ds-mine/test/#{file_name}.txt"

    File.unlink path if File.file? path
  end

  def without_file
    delete_list_file
    yield
    delete_list_file
  end

  it 'delegates [] []= to items' do
    new_items = %w(one two)

    list[1..-2] = new_items

    assert_equal list[1..-2], new_items
  end

  it 'delegates to [] to items' do
    assert_equal list[1..-2], items[1..-2]
  end

  it 'returns items length' do
    assert_equal items.size, list.size
  end

  it 'pushes onto list' do
    orig_items = items.dup

    tools = 'bucket and spade'

    list << tools

    assert_equal list, orig_items + [tools]
  end

  it 'checks equality on items against named list' do
    assert_equal list, list_class.new(items, 'morris miner')
  end

  it 'checks equality on items against unnamed list' do
    assert_equal list, list_class.new(items)
  end

  it 'checks equality on items against array' do
    assert_equal list, items
  end

  it 'saves' do
    without_file do
      list.dump

      assert File.file? list.path
    end
  end

  it 'restores' do
    without_file do
      list.dump

      assert_equal list_class.load(file_name, 'test'), items
    end
  end

  it 'removes' do
    list.dump

    list.rm

    refute File.file? list.path
  end
end
