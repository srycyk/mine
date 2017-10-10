require "test_helper"

require_relative '../support/html_example'

describe Mine::Extract::Extractor do
  let(:html) { HtmlExample.new.() }

  let(:extractor) { Mine::Extract::Extractor.new html }

  let(:heading) { 'Example Domain' }

  it 'extracts' do
    output = extractor.() {|page, out| out << page.css('h1').text }

    assert_equal heading, output.first
  end

  it 'extracts into string' do
    output = extractor.('') {|page, out| out << page.css('h1').text }

    assert_equal heading, output
  end

  it 'extracts into closure string' do
    out = ''
    extractor.(out) {|page, out| out << page.css('h1').text }

    assert_equal heading, out
  end

  it 'keeps results of extraction' do
    extractor.() {|page, out| out << page.css('title').text }
    extractor.() {|page, out| out << page.css('h1').text }

    assert_equal 2, extractor.output.size
    assert_equal heading, extractor.output.first
    assert_equal heading, extractor.output.last
  end

  it 'clears results of extraction' do
    extractor.() {|page, out| out << page.css('h1').text }

    extractor.clear

    refute extractor.output.any?
  end
end

