require "test_helper"

require 'mine/concerns/sequence_template'

describe Mine::Concerns::SequenceTemplate do
  let(:from) { 'test/concerns/' }

  let(:template) { Mine::Concerns::SequenceTemplate.new 'second', [ from ] }

  it 'works' do
    expected = [ 'Zero Two (1)', 'Zero Two (2)' ]

    assert_equal expected, template.call
  end
end

