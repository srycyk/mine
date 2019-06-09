
module ProxyHelpers
  def proxy_address(*ip_and_port)
    Mine::Fetch::Proxy::Address.new *ip_and_port
  end

  def stub_provider(provider, response)
    provider.stub :fetch, ProxyResponseStub.new.(response) do |provider|
      yield provider
    end
  end

  def error_response
    '{ }'
  end
end
