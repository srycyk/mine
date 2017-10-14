
#require "mine/fetch/http/url_to_uri"
#require 'mine/fetch/http/follow_redirect'

module Mine
  module Fetch
    module Http
      class Headers < Struct.new(:http_request)
        HEADER_FILE = 'http-headers'
        COOKIE_DIR = 'log/cookies'

        def call
          user_agent

          set_default

          read_default

          load_cookie

          csrf_token

          http_request.to_hash
        end

        def read_default
          sub_dirs = Storage::DataLocator.shallow_root

          config = App::TaskUtils::CONFIG

          dirs = [ File.join(sub_dirs, config),
                   File.join(config, sub_dirs.last),
                   config ]


          headers = Concerns::ConfigFile.new HEADER_FILE, dirs, accumulate: true

          headers.().each {|name, value| http_request[name] = value }
        end

        def load_cookie
          store = self.class.cookie_store host

          if store.exists?
            cookie = store.load.chomp

            http_request['cookie'] = cookie
          end
        end

        def csrf_token
          # TODO add to form fields?
        end

        def set_default
          #http_request['Host'] = host
        end

        def host
          http_request.uri.host
        end

        def user_agent
          index = host.hash % user_agents.size

          agent = user_agents[index]

          http_request['User-Agent'] = agent
        end

        def user_agents
          @user_agents ||= begin
            [ 'Mozilla/5.0 (Macintosh; PPC Mac OS X x.y; rv:10.0) Gecko/20100101 Firefox/10.0',
              'Mozilla/5.0 (Windows NT x.y; WOW64; rv:10.0) Gecko/20100101 Firefox/10.0',
              'Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20100101 Firefox/10.0',
              'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.86 Safari/537.36',
              'Mozilla/5.0 (Android 4.4; Tablet; rv:41.0) Gecko/41.0 Firefox/41.0'
            ]
          end
        end

        class << self
          def store_cookie(host_name, headers, sub_dir=nil)
            if value = cookie_values(headers['set-cookie'])
              cookie_store(host_name).dump value if value !~ /^\s*$/
            end
          end

          def delete_cookie(host_name)
            cookie_store(host_name).rm
          end

          def cookie_store(host_name)
            Storage::DataSaver.new host_name, sub_dir: COOKIE_DIR,
                                              deep_base: true
          end

          def cookie_values(cookie_text)
            out = ''

            cookie_text = (cookie_text || []).join ' '

            return out unless cookie_text

            cookie_text.split(/\spath=\/[\d\w\/]*[,;]?/i).each do |kookie|
              out << '; ' if out.size > 0
              kookie.sub!(/;?\sexpires.*GMT\s?,?/i, '')
              kookie.sub!(/;$/, '')
              #kookie << ' path=/'
              out << kookie
            end
            #out.squeeze
            out
          end
        end
      end
    end
  end
end

