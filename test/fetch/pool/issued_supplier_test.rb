require "test_helper"

require_relative "issuer_utils"

describe Mine::Fetch::Pool::IssuedSupplier do
  include IssuerUtils

  def issued_supplier(factories, tries)
    Mine::Fetch::Pool::IssuedSupplier.new factories, tries
  end

  before { reset }

  describe 'more than one try' do
    (2..4).each do |proxy_tries|
      it "rotates with #{proxy_tries}" do
        supplier = issued_supplier factories_2, proxy_tries

        (1..proxy_tries).each do
          issued = supplier.()
          assert_equal split(addresses_1[0]), issued.to_a
        end

        (1..proxy_tries).each do
          issued = supplier.()
          assert_equal split(addresses_2[0]), issued.to_a
        end

        (1..proxy_tries).each do
          issued = supplier.()
          assert_equal split(addresses_2[1]), issued.to_a
        end
      end
    end

    it 'goes to next factory if invalid' do
    end

    it 'runs out' do
      supplier = issued_supplier factories_2, 2

      (1..6).each do
        assert supplier.()
      end

      refute supplier.()
    end

    it 'dies when killed' do
      supplier = issued_supplier factories_2, 2

      issued = supplier.()

      assert_equal split(addresses_1[0]), issued.to_a

      issued.die

      issued = supplier.()

      assert_equal split(addresses_2[0]), issued.to_a
    end
  end
end
