require "test_helper"

require 'mine/concerns/sequence_numeric'

=begin
class ItemFactory < Struct.new(:name, :items, :eternal)
  include Mine::Concerns::DeadOrAlive

  def call
    items.shift or (eternal and return) or die
  end
end

describe Mine::Scrape::ListIteratorWithIssued do
  ENOUGH, TOO_MANY = 10, 20
  TRIES = 2

  def issue_names
    [ %w(a b c), %w(1 2 3), %w(10 11 12) ]
  end

  def issued_list(eternal=nil)
    Mine::Scrape::ListIteratorWithIssued.new providers(eternal), TRIES
  end

  def providers(eternal)
    [ ItemFactory.new('a1', issue_names[0], eternal),
      ItemFactory.new('a2', issue_names[1], eternal),
      ItemFactory.new('a3', issue_names[2], eternal) ]
  end

  def sequence(limit)
    Mine::Concerns::SequenceNumeric.new('item-%s', limit).()
  end

  def item_list(limit=ENOUGH)
    Mine::Storage::CycleListSave.get('sequence', 'test') { sequence limit }
  end

  def each_item_and_issue(list_limit, eternal)
    issued_list(eternal).(item_list list_limit) do |item, issue|
      yield item, issue
    end
  end

  after { item_list.rm }

  [ nil, true ].each do |eternal|
    factory_type = "#{eternal ? 'stay alive' : 'dying'} factory"

    it "cycles with #{factory_type}" do
      expected_sequence = sequence ENOUGH

      issuer = each_item_and_issue ENOUGH, eternal do |item, issue|
                 assert expected_sequence.shift, item
               end

      assert_empty expected_sequence
      assert_equal ENOUGH/TRIES, issuer.log.send(:issued_total)
    end

    it "aborts cycle with #{factory_type}" do
      expected_sequence = sequence TOO_MANY

      issuer = each_item_and_issue TOO_MANY, eternal do |item, issue|
                 assert expected_sequence.shift, item
               end

#puts issuer
      assert_equal expected_sequence.shift, 'item-19'
      assert_equal issue_names.flatten.size, issuer.log.send(:issued_total)
    end
  end
end
=end

