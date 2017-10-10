
module Mine
  module Scrape
    class ListIteratorWithIssued < Struct.new(:providers, :max_tries)
      def call(list)
        current = first_value(list)

        return unless current

        Fetch::Pool::Issuer.each(providers) do |issued, issuer|
          issued.set_max(max_tries)

          issued.each do |issued|
            yield current, issued

            current = next_value(list)

            break unless current
          end

          break issuer unless current
        end
      end

      def first_value(list)
        list.resume if list.respond_to? :resume

        list.current
      end

      def next_value(list)
        list.respond_to?(:succ!) ? list.succ! : list.succ
      end

      def finished?
        list.succ?
      end
    end
  end
end
