require "test_helper"

require_relative "issuer_utils"

describe Mine::Fetch::Pool::Issuer do
  include IssuerUtils

  before { reset }

  describe 'with one try' do
    describe 'with one factory' do
      it 'issues alive' do
        assert issuer.().alive?
      end

      it 'issues first address' do
        assert_equal addresses_1.first.split(' '), issuer.().to_a
      end

      it 'skips empty addresses' do
        issuer = issuer(factories: [ factory(empty_lines + addresses_1) ])

        assert_equal addresses_1.first.split(' '), issuer.().to_a
      end

      it 'skips invalid addresses' do
        issuer = issuer(factories: [ factory(invalid_lines + addresses_1) ])

        assert_equal addresses_1.first.split(' '), issuer.().to_a
      end

      it 'runs out' do
        issuer = issuer()

        issuer.()

        assert_nil issuer.()
        assert issuer.dead?
      end

      it 'adds valid addresses' do
        issuer = issuer(factories: [ factory(invalid_lines + addresses_2) ])

        issuer.()
        issuer.()

        assert_equal 2, issuer.log.counts.values.inject(&:+)
      end

      it 'adds invalid addresses' do
        issuer = issuer(factories: [ factory(invalid_lines + addresses_1) ])

        issuer.()

        assert_equal invalid_lines.size,
                     issuer.log.errors[:invalid_issue]['lines-3']
      end
    end

    def assert_issued_list(isuuer, expected_list)
      expected_list.each do |item|
        assert_equal split(item), issuer.().to_a
      end
    end

    describe 'with two factories' do
      it 'rotates' do
        issuer = issuer(factories: factories_2)

        assert_issued_list issuer,
                           [ addresses_1[0], addresses_2[0], addresses_2[1] ]

        assert_nil issuer.()
        assert issuer.dead?
      end
    end

    describe 'with three factories' do
      it 'rotates' do
        issuer = issuer(factories: factories_3)

        assert_issued_list issuer, [ addresses_1[0], addresses_2[0],
                                     addresses_3[0], addresses_2[1],
                                     addresses_3[1], addresses_3[2] ]

        assert_nil issuer.()
        assert issuer.dead?
      end
    end
  end

  def assert_issued_tries(issuer, tries, expected)
    issued = issuer.()
    (1..tries).each do
      assert_equal split(expected), issued.().to_a
    end
    refute issued.()
  end

  describe 'more than one try' do
    (2..4).each do |proxy_tries|
      it "rotates with #{proxy_tries}" do
        issuer = issuer(factories: factories_2, tries: proxy_tries)

        assert_issued_tries issuer, proxy_tries, addresses_1[0]

        assert_issued_tries issuer, proxy_tries, addresses_2[0]

        assert_issued_tries issuer, proxy_tries, addresses_2[1]
      end
    end

    it 'remains valid up to max tries' do
      tries = 5

      issuer = issuer(factories: factories_1, tries: tries)

      issued = issuer.()

      (1..tries).each { assert issued.().alive? }

      refute issued.dead?
    end

    it 'invalidates once max tries exceeded' do
      tries = 5

      issuer = issuer(factories: factories_1, tries: tries)

      issued = issuer.()

      assert issued.alive?

      (1..tries + 1).each { issued.() }

      assert issued.dead?

      refute issued.()
    end

    it 'goes to next factory if invalid' do
    end

    it 'runs out' do
      issuer = issuer(factories: factories_2, tries: 2)

      (1..3).each do
        assert issuer.()
      end

      refute issuer.()

      assert issuer.dead?
    end

    it 'dies when killed' do
      issuer = issuer(factories: factories_2, tries: 2)

      issued = issuer.()

      assert_equal split(addresses_1[0]), issued.to_a

      issued.die

      issued = issuer.()

      assert_equal split(addresses_2[0]), issued.to_a
    end
  end
end
