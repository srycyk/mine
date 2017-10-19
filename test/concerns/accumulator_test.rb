require "test_helper"

require 'mine/app/accumulator'

describe Mine::App::Accumulator do
  MATCH = /a,b,c\sx,y,z/

  let(:acca) { Mine::App::Accumulator.new 'acca', 'test' }

  def to_match(csv)
    csv.map(&:chomp) * ' '
  end

  it 'converts to csv' do
    acca.add('2', %w(x y z))
    acca.add('1', %w(a b c))

    assert_match MATCH, to_match(acca.csv)
  end

  it 'converts to csv with nil key' do
    acca.add(nil, %w(a b c))
    acca.add(nil, %w(x y z))

    assert_match MATCH, to_match(acca.csv)
  end

  it 'substitutes sequence into key' do
    acca.add([ 'f', nil ], %w(a b c))

    assert_equal "f^00001", acca.dict.dict.keys.first
  end

  it 'appends a value with <<' do
    acca.add [nil], %w(a b c)
    acca.add [nil], %w(x)

    acca << 'y' << 'z'

    assert_match MATCH, to_match(acca.csv)
  end

  it 'appends values with +' do
    acca.add [nil], %w(a b c)
    acca.add [nil]

    acca + %w(x y) + 'z'

    assert_match MATCH, to_match(acca.csv)
  end
end

