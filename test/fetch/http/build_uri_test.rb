require "test_helper"

describe Mine::Fetch::Http::BuildUri do
  let(:scheme) { 'http' }
  let(:host) { 'www.maths.co.uk' }
  let(:path) { 'some/formulars' }
  let(:query) { 'e=mc2&c=2pir' }

  let(:server) { "#{scheme}://#{host}" }
  let(:site) { "#{server}/#{path}" }
  let(:url) { "#{site}?#{query}" }

  let(:uri) { URI.parse url }

  let(:params) { { 'e' => 'mc2', 'c' => '2pir' } }
  let(:param)  { { 'i' => '2.54cm' } }

  let(:build_uri_class) { Mine::Fetch::Http::BuildUri }

  let(:build_uri) { build_uri_class.new url }

  it 'returns params' do
    assert_equal params, build_uri.params
  end

  it 'sets params' do
    build_uri.params = param
    assert_equal param, build_uri.params
  end

  it 'merges params' do
    assert_equal params.merge(param), build_uri.merge(param).params
  end

  it 'deletes' do
    expected_params = { 'e' => 'mc2' }

    assert_equal expected_params, build_uri.delete('c').params
  end

  it 'returns path' do
    assert_equal path, build_uri.path
  end

  it 'sets path' do
    build_uri.path = 'finder'

    assert_equal 'finder', build_uri.path
  end

  it 'replaces substring in path' do
    assert_equal 'some/formulae',
                 build_uri.replace('formulars', 'formulae').path
  end

  it 'sets element' do
    expected = url.sub /^http/, 'https'

    assert_equal expected, build_uri.set(scheme: 'https').to_s
  end

  %w(path/to/cgi.php?x=y path path path/to cgi.php?x=y).each do |relative|
    it "makes absolute: #{relative}" do
      assert_equal "#{server}/#{relative}", build_uri.absolute(relative).to_s
    end
  end

  it 'makes absolute' do
    assert_equal 'http://www.maths.co.uk/path/to/page.html',
                  build_uri_class.absolute('/path/to/page.html', build_uri.to_s)
  end
end

