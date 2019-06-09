
module SharedProxyAssertions
  def self.included(base)
    base.instance_eval do
      it 'returns address' do
        stub_provider provider, raw_response do |provider_stub|
          assert_equal address, provider_stub.call
        end
      end

      it 'handles error' do
        stub_provider provider, error_response do |provider_stub|
#puts provider_stub.inspect
          assert_nil provider_stub.call
        end
      end

      it 'initialise name' do
        assert provider.name
      end
    end
  end
end
