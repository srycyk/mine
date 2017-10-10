require "test_helper"

describe Mine::Storage::ListDataItem do
  let(:file_name) { 'list_data_item' }
  let(:ext) { 'text' }

  let(:items) { %w(one two three) }

  let(:list) { Mine::Storage::CycleListSave.new [], file_name, 'test/lists' }

  let :data_items do
    %w(First Second Third)
  end

  def delete_files
    dir = "tmp/ds-mine/test/lists/"

    files = [ "#{file_name}.txt", "#{file_name}-index.txt",
              "#{file_name}/0000.#{ext}", "#{file_name}/0001.#{ext}" ]

    files.each do |file|
      path = "#{dir}#{file}"

      File.unlink path if File.file? path
    end
  end

  def without_file
    delete_files
    yield
    delete_files
  end

  it 'points to subdir' do
    assert_equal file_name, list.data_item.sub_dir.last
  end

  it 'generates file name' do
    assert_equal '0000', list.data_item.file_name
  end

  it 'pushes first' do
    without_file do
      refute list.exists?

      list.push! items[0]

      assert list.exists?
      assert_equal items.first, list.current
    end
  end

  it 'adds first' do
    without_file do
      refute list.exists?

      list.add_data_item items[0], data_items[0], ext

      list.reset

      assert list.data_item(ext).exists?
      assert_equal data_items.first, list.data_item!(ext).chomp
    end
  end

  it 'puts' do
    without_file do
      list.data_item(ext).put("Number One\n")

      data_item = list.data_item(ext)

      assert data_item.exists?
      assert_equal "Number One\n", data_item.()
    end
  end

  # TODO - push! and add_data_item as well
  it 'removes' do
    #list.data_item.put('Number One')
    #list.data_item.put('Number Three', 2)
  end
end
