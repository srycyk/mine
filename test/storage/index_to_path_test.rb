require "test_helper"

describe Mine::Storage::IndexToPath do
  def index_to_path(sub_dir='subdir', ext=:html, mkdir=false)
    Mine::Storage::IndexToPath.new(sub_dir, ext, mkdir)
  end

  it 'converts to dir' do
    assert_equal 'subdir/02', index_to_path.dir(2099)
    assert_equal '099.html', index_to_path.file(2099)
    assert_equal 'subdir/02/099.html', index_to_path.(2099)
  end

  it 'converts to dir with string' do
    assert_equal 'subdir/00', index_to_path.dir('1')
    assert_equal '001.html', index_to_path.file('1')
    assert_equal 'subdir/00/001.html', index_to_path.('1')
  end

  it 'converts to bare path with defaults' do
    assert_equal '99', index_to_path(nil, nil).dir(99_999)
    assert_equal '999', index_to_path(nil, nil).file(99_999)
    assert_equal '99/999', index_to_path(nil, nil).(99_999)
  end

  it 'omits extension but includes subdir' do
    assert_equal 'sd/09', index_to_path(:sd, nil).dir(9_999)
    assert_equal '999', index_to_path(:sd, nil).file(9_999)
    assert_equal 'sd/09/999', index_to_path(:sd, nil).(9_999)
  end

  it 'omits subdir but includes extension' do
    assert_equal '90', index_to_path(nil, :txt).dir(90_099)
    assert_equal '099.txt', index_to_path(nil, :txt).file(90_099)
    assert_equal '90/099.txt', index_to_path(nil, :txt).(90_099)
  end

  it 'accepts Array as sub_dir' do
    assert_equal 's1/s2/01', index_to_path(%w(s1 s2), nil).dir(1000)
    assert_equal '000', index_to_path(%w(s1 s2), nil).file(1000)
    assert_equal 's1/s2/01/000', index_to_path(%w(s1 s2), nil).(1000)
  end
end

