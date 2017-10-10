require "test_helper"

describe Mine::Fetch::Pool::Issued do
  let(:address) { Mine::Fetch::Proxy::Address.new("0.1.2.3", "4") }

  let(:issued) { Mine::Fetch::Pool::Issued.new(address) }

  def max
    issued.max_tries
  end

  it 'returns ip and port as array from wrapped object' do
    assert_equal %w(0.1.2.3 4), issued.to_a
  end

  it "responds to method 'name' on wrapped object" do
    assert issued.respond_to? :name
  end

  it 'returns itself when called' do
    assert_equal issued, issued.()
  end

  it 'starts off alive' do
    issued.()

    assert issued.alive?
    refute issued.dead?
  end

  it 'counts calls' do
    (1..3).each { issued.() }

    assert_equal 3, issued.num_tries
  end

  it 'invalidates' do
    issued.die

    assert issued.dead?
    refute issued.alive?
  end

  it 'remains valid until tries at max' do
    (1..max).each { assert issued.() }

    assert issued.alive?
  end

  it 'remains valid before tries at max' do
    (1...max).each { issued.() }

    assert issued.()
    assert issued.alive?

    refute issued.()
    assert issued.dead?
  end

  it 'invalidates when max tries exeeded' do
    (1..max).each { issued.() }

    refute issued.()
    assert issued.dead?
  end

  it 'call returns nil if invalidated' do
    issued.die

    assert_nil issued.()
  end

  it 'counts through' do
    (1..max).each { issued.() }
  end

=begin
  it 'spins through with valid address' do
    issued.each {|issued| assert issued.valid? }

    assert issued.dead?
  end

  it 'spins through until max tries reached' do
    count = 0

    issued.each {|_| count += 1 }

    assert_equal issued.max_tries, count
    assert_equal issued.num_tries, count + 1
  end

  it 'spins through until death' do
    count, tries = 0, issued.max_tries / 2

    issued.each do |_|
      count += 1

      issued.die if count >= tries
    end

    assert_equal issued.num_tries, tries
  end
=end
end
