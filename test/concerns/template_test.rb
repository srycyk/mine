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
    assert_equal 'Zero One', template.call(%w(prefix infix))
  end
end

