
require_relative "response_stub"
require_relative "site_to_content"

class ProxyFactory < Struct.new(:proxies, :name)
  include Mine::Concerns::DeadOrAlive

  def call
    proxies.shift or die
  end
end

module TaskHelpers
  def task_options(removal=false)
    Mine::Scrape::TraversalOptions.new pause: 0, remove_on_error: removal,
                                       retries: 1, retries_pause: 0
  end

  def sites_to_content(path_to_excerpt=mappings)
    @sites_to_content ||= SiteToContent.new(path_to_excerpt)
  end

  def cyclist(sites)
    Mine::Storage::CycleListSave.get('follow', 'test/scrape') { sites }
  end

  def sites
    sites_to_content.sites
  end

  def site_list(listing=nil)
    @site_list ||= cyclist(listing || sites)
  end

  def reset
    @sites_to_content, @site_list, @proxy_addresses = []
  end

  def clean
    site_list.rm
  end

  def response_stub(body: '', success: (!body.nil?))
    ResponseStub.new(body: body, success: success).()
  end

  def response_for_site
    -> (site, _) { response_stub body: sites_to_content.(site) }
  end

  def stub_task(task, response, output='')
    if String === response or response.nil?
      response = response_stub(body: response)
    end

    task.set_log_to(output).stub :get_page, response do |task|
      yield task
    end
  end

  def stub_task_error(task)
    task.stub :get_page, -> (*) { raise 'A forced error' } do |task|
      yield task.set_log_to('')
    end
  end

  def proxy_address
    ip = "#{rand 256}.#{rand 256}.#{rand 256}.#{rand 256}"

    Mine::Fetch::Proxy::Address.new ip, rand(9999) + 1
  end
  def proxy_addresses
    @proxy_addresses ||= (1..2).map { proxy_address }
  end

  def proxy_providers
    (1..2).map {|count| ProxyFactory.new proxy_addresses, count.to_s }
  end

  def set_proxy(task, tries=2, providers=proxy_providers)
    task.set_proxy_issuer providers, tries
  end
end

