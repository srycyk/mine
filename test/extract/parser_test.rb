require "test_helper"

require_relative '../support/html_example'

describe Mine::Extract::Parser do
  let(:html) { HtmlExample.new.() }

  let(:parser) { Mine::Extract::Parser.new html }

  let(:heading) { 'Example Domain' }

  it 'parses' do
    assert_equal heading, parser.().css('h1').text
  end

  it 'parses with block' do
    parser.() {|page| assert_equal heading, page.css('h1').text }
  end

  it 'returns result of parsed block' do
    result = parser.() {|page| page.css('h1').text }

    assert_equal heading, result
  end
end

