require "test_helper"

require 'mine/concerns/config_file'

describe Mine::Concerns::ConfigFile do
  let(:sub_dir) { 'test' }

  let(:template) { 'template' }

  let(:temp_file_dir) { "tmp/ds-mine/#{sub_dir}" }

  let(:dirs) { [ temp_file_dir, sub_dir, "test/concerns" ] }

  let(:config_file_class) { Mine::Concerns::ConfigFile }

  let(:config_file) { config_file_class.new template, dirs }

  let(:config_file_empty) { config_file_class.new 'xxxx', dirs }

  let(:json) { '{ "prefix": "New" }' }

  let(:ruby_hash) { '{ prefix: "New" }' }

  def with_temp_file(contents=json, ext='json')
    path = "#{temp_file_dir}/#{template}.#{ext}"

    File.open(path, 'w') {|stream| stream.puts contents }

    yield
  ensure
    File.unlink path if File.exists? path
  end

  it 'finds ./test/concerns/template.json' do
    assert_equal 'Zero ', config_file.()['prefix']
  end

  it 'returns empty hash if template not found' do
    assert_equal Hash.new, config_file_empty.()
  end

  it 'reads ruby file' do
    with_temp_file ruby_hash, 'rb' do
      assert_equal 'New', config_file.()['prefix']
    end
  end

  it 'accumulates' do
    config_file = config_file_class.new template, dirs, accumulate: true

    with_temp_file do
      assert_equal 'New', config_file.()['prefix']
    end
  end
end

