require "test_helper"

unless ENV['OFFLINE']
  describe Mine::Fetch::Http::Agent do
    let(:agent) { Mine::Fetch::Http::Agent.new("http://example.com/") }

    let(:response) { agent.() }

    it 'fetches with success' do
      assert response.success?
    end

    it 'fetches body' do
      assert_match /^\s*<!doctype html>/, response.to_s
    end
  end
end

