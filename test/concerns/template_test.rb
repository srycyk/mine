require "test_helper"

require 'mine/concerns/template'

describe Mine::Concerns::Template do
  let(:file) { 'template.json' }

  let(:template) { Mine::Concerns::Template.new 'first', nil, [ 'xxxx', to ] }

  let(:from) { 'test/concerns/' }
  let(:to) { 'tmp/ds-mine/test/' }

  before { system "cp #{from}#{file} #{to}" }

  after { File.unlink "#{to}#{file}" }

  it 'works' do
    assert_equal 'Zero One (x)', template.call % 'x'
  end

  it 'gets elements' do
    assert_equal 'Zero One', template.call(%w(prefix infix))
  end

  it 'gets element' do
    assert_equal 'Zero ', template.element(:prefix)
  end

  it 'gets first element' do
    assert_equal 'Zero ', template.element
  end

  it 'gets first element with base' do
    assert_equal 'Zero ', template.base
  end
end

