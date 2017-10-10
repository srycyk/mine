require "test_helper"

describe Mine::Fetch::Http::EscapeUri do
  let(:params) { { 'e' => 'mc2', 'c' => '2pir' } }
  let(:query) { 'e=mc2&c=2pir' }

  let(:escape_uri_class) { Mine::Fetch::Http::EscapeUri }

  let(:escape_uri) { escape_uri_class.new }

  let(:uri_params) { escape_uri_class.new params }
  let(:uri_query) { escape_uri_class.new query }

  it 'converts to query' do
    assert_equal query, uri_params.(:query)
  end

  it 'converts to query as constructor argument' do
    assert_equal query, escape_uri_class.new(params, :query).()
  end

  it 'converts to params' do
    assert_equal params, uri_query.(:params)
  end

  it 'converts to query as constructor argument' do
    assert_equal params, escape_uri_class.new(query, :params).()
  end

  it 'leaves params as params' do
    assert_equal params, uri_params.(:params)
  end
end

