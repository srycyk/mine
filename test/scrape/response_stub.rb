
class ResponseStub
  attr_accessor :success, :body

  def initialize(success: true, body: '')
    self.success = success

    self.body = body
  end

  def call(data=nil)
    this = self

    Class.new do
      define_method :success? { this.success ? true : false }

      define_method :body { data || this.body }

      define_method :saver {|_| -> (*) { } }

      define_method :info { "Error Info - ResponseStub #{body}" }
    end.new
  end
end
