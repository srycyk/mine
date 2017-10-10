require "test_helper"

unless ENV['OFFLINE']
  describe Mine::Fetch::Http::Get do
    let(:get) { Mine::Fetch::Http::Get.new("http://example.com/") }

    let(:response) { get.() }

    it 'fetches with success' do
      assert Net::HTTPOK === response.http_response
    end

    it 'fetches body' do
      assert_match /^\s*<!doctype html>/, response.body
    end
  end
end
