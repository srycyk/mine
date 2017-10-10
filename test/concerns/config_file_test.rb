require "test_helper"

require 'mine/concerns/config_file'

describe Mine::Concerns::ConfigFile do
  let(:dirs) { [ 'test', 'test/concerns' ] }

  let(:config_file_class) { Mine::Concerns::ConfigFile }

  let(:config_file) { config_file_class.new 'template', dirs }

  let(:config_file_empty) { config_file_class.new 'xxxx', dirs }

  def temp_file_dir
    "tmp/ds-mine/test"
  end

  def temp_file
    path = "#{temp_file_dir}/template.json"

    json = '{ "prefix": "New" }'

    File.open(path, 'w') {|stream| stream.puts json }

    yield
  ensure
    File.unlink path if File.exists? path
  end

  it 'works' do
    assert_equal 'Zero ', config_file.()['prefix']
  end

  it 'returns empty hash if nothing found' do
    assert_equal Hash.new, config_file_empty.()
  end

  it 'accumulates' do
    dirs = [ temp_file_dir, *dirs ]

    config_file = config_file_class.new 'template', dirs, accumulate: true

    temp_file { assert_equal 'New', config_file.()['prefix'] }
  end
end

