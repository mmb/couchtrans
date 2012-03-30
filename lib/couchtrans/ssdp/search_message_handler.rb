require 'time'

module Couchtrans

  module Ssdp

    class SearchMessageHandler
      include Logged

      def handle(message, sender)
        if message.meth == 'M-SEARCH' and
          message.headers['st'] =~ /:ContentDirectory:1$/

          response = Message.new
          response.meth = 'OK'
          response.headers = {
            :'cache-control' => 'max-age=1800',
            :date => Time.now.httpdate,
            :ext => '',
            :location => 'http://192.168.1.3:4567/',
            :server => SERVER_HEADER,
            :st => 'urn:schemas-upnp-org:service:ContentDirectory:1',
            :usn => "uuid:#{Server::Uuid}::urn:schemas-upnp-org:service:ContentDirectory:1",
          }

          log.debug("sending response\n#{response}")
          begin
            socket = UDPSocket.open
            socket.send response.to_s, 0, sender[3], sender[1]
          ensure
            socket.close 
          end

        end

      end

    end

  end

end
