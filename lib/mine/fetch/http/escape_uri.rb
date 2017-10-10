
require "uri"

module Mine
  module Fetch
    module Http
      class EscapeUri < Struct.new(:candidate, :type)
        # TODO ensure [model][fields..] handled
        TYPES = %i(query params) # TODO list of /<name>\s*[:=]?\s*<value>/

        def call(type=nil)
          if want_params? type
            return to_params if got_query?
          elsif want_query? type
            return to_query if got_params?
          end

          candidate
        end

        def to_query
          URI.encode_www_form candidate
        end

        def to_params
          URI.decode_www_form(candidate).to_h
        end

        private

        def target_type(type=nil)
          type or self.type or TYPES.first
        end

        def want_query?(type=nil)
          target_type(type) == TYPES.first
        end

        def want_params?(type=nil)
          target_type(type) == :params
        end

        def current_type
          Hash === candidate ? :params : TYPES.first
        end

        def got_query?
          current_type == TYPES.first
        end

        def got_params?
          current_type == :params
        end
      end
    end
  end
end

