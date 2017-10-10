require "test_helper"

describe Mine::Storage::DataSaver do
  let(:save_name) { :morris_miner }

  let(:saver_class) { Mine::Storage::DataSaver }

  let(:saver) { saver_class.new save_name, sub_dir: 'test' }

  let(:string) { "mining ...\n" }

  let(:lines) { %w(hi ho off we go) }

  let(:json) { { 'and' => 'the', 'argo' => "00000000" } }

  let(:csv_array) { [ %w(a b c), %w(x y x) ] }
  let(:csv_text) { "a,b,c\nx,y,x\n" }

  def saver_opts(**opts)
    saver.options = opts
    saver
  end

  after { saver.rm }

  it 'saves and restores string' do
    saver.dump string

    assert_equal string, saver.load
  end

  it 'saves and restores lines' do
    saver.dump lines

    assert_equal lines, saver.load(:as_lines)
  end

  it 'restores lines' do
    saver.dump lines

    test_saver = saver_class.new save_name, mode: :lines, sub_dir: 'test'

    assert_equal lines, test_saver.load
  end

  it 'saves and restores json' do
    saver.dump json

    assert_equal json, saver.load(:as_json)
  end

  it 'saves json with file extension' do
    saver.dump json

    assert_match /\.json$/, saver.path
  end

  it 'saves array with json extension' do
    saver_opts ext: 'json'

    assert_match /\.json$/, saver.path
  end

  it 'saves and restores csv' do
    saver.dump csv_array

    assert_equal csv_array, saver.load(:as_csv)
  end

  it 'saves and restores csv text' do
    saver.dump csv_array

    assert_equal csv_text, saver.load(:as_string)
  end

  it 'saves csv with file extension' do
    saver.dump csv_array

    assert_match /\.csv$/, saver.path
  end

  it 'goes under a branch dir' do
    original = Mine::Storage::DataLocator.root
    Mine::Storage.under :branch do |root|
      assert_equal :branch, Mine::Storage::DataLocator.root.last

      assert_equal root, Mine::Storage::DataLocator.root
    end
    refute_equal :branch, Mine::Storage::DataLocator.root.last

    assert_equal original, Mine::Storage::DataLocator.root
  end

  it 'sings deep_base' do
    Mine::Storage.under :branch do |root|
      refute_match /branch/, saver_class.new('tenor', deep_base: true).path

      assert_match /branch/, saver_class.new('alto').path
    end
  end
end
