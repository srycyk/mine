require "test_helper"

unless ENV['OFFLINE']
  describe Mine::Fetch::Http::Getter do
    let(:getter) { Mine::Fetch::Http::Getter.new("http://example.com/") }

    let(:response) { getter.() }

    it 'fetches with success' do
      response

      assert Net::HTTPOK === getter.http_response
    end

    it 'fetches body' do
      assert_match /^\s*<!doctype html>/, response
    end
  end
end

