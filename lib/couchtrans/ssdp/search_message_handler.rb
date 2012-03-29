module Couchtrans

  module Ssdp

    class SearchMessageHandler
      include Logged

      def handle(message, sender)
        if message.meth == 'M-SEARCH'
          log.debug 'received search message'
        end

      end

    end

  end

end
