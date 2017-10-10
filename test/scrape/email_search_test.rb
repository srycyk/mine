require "test_helper"

describe Mine::Scrape::EmailSearch do
  let(:mail1) { 'mr.1@www.xxx.co.uk' }
  let(:mail2) { 'mr.2@www.xxx.co.uk' }

  let(:all_mails) { [ mail1, mail2 ] }

  let :html do
    %(
      <li class="header-email"><a href="mailto:#{mail1}">#{mail1}</a></li>
      <div>#{mail2}</div>
      <a href="mailto:#{mail2}">Send</a>
    )
  end

  let(:search) { Mine::Scrape::EmailSearch.new html }

  it 'finds all' do
    assert_equal search.call, all_mails
  end

  it 'finds by re' do
    assert_equal search.by_re.sort.uniq, all_mails
  end

  it 'finds by href' do
    assert_equal search.by_href.sort.uniq, all_mails
  end
end

