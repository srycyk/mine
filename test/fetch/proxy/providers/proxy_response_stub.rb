
class ProxyResponseStub
  def call(raw_response)
    Class.new do
      define_method :success? { true }

      define_method :body { raw_response }

      define_method :saver { -> (*) { } }
    end.new
  end
end
