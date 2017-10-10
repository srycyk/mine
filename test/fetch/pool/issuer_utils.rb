
module IssuerUtils
  def factory(lines, name="lines-#{lines.size}")
    Mine::Fetch::Proxy::ProviderAddressLists.new name, lines
  end

  def address_line
    "#{rand 256}.#{rand 256}.#{rand 256}.#{rand 256} #{rand(9999) + 1}"
  end

  def address_lines(count=2)
    (1..count).map { address_line }
  end

  def issuer(factories: factories_1, tries: 1)
    @issuer ||= Mine::Fetch::Pool::Issuer.new(factories, tries)
  end

  def split(line)
    line.split /\s+/
  end

  def invalid_lines
    %w(xxx 1.2.3)
  end
  def empty_lines
    [ '', ' ', '#1.2.3.4' ]
  end

  def addresses_1
    @addresses_1 ||= address_lines 1
  end
  def addresses_2
    @addresses_2 ||= address_lines 2 
  end
  def addresses_3
    @addresses_3 ||= address_lines 3
  end

  def factories_1
    @factories_1 ||= [ factory(addresses_1) ]
  end
  def factories_2
    @factories_2 ||= [ *factories_1, factory(addresses_2) ]
  end
  def factories_3
    @factories_3 ||= [ *factories_2, factory(addresses_3) ]
  end

  def reset
    @issuer = nil
    @addresses_1, @addresses_2, @addresses_3 = []
    @factories_1, @factories_2, @factories_3 = []
  end
end
