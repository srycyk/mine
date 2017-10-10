require "test_helper"

require 'mine/concerns/template'

describe Mine::Concerns::Template do
  let(:template) { Mine::Concerns::Template.new 'first', [ 'xxxx', to ] }

  let(:file) { 'template.json' }
  let(:from) { 'test/concerns/' }
  let(:to) { 'tmp/ds-mine/test/' }

  before { system "cp #{from}#{file} #{to}" }

  after { File.unlink "#{to}#{file}" }

  it 'works' do
    assert_equal 'Zero One', template.call(%w(prefix infix))
  end
end

