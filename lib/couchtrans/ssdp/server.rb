require 'ipaddr'
require 'socket'

require 'guid'

module Couchtrans

  module Ssdp
    MulticastIp = '239.255.255.250'
    Port = 1900

    class Server
      include Logged

      Uuid = Guid.new

      def initialize(ip)
        @ip = ip
        @message_handlers = [
          SearchMessageHandler.new
          ]
      end

      def start
        log.debug 'start'
        socket = UDPSocket.new
        socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP,
          IPAddr.new(MulticastIp).hton + IPAddr.new(ip).hton)
        socket.bind Socket::INADDR_ANY, Port

        loop { handle_message(*socket.recvfrom(1024)) }
      end

      def handle_message(message, sender)
        log.debug "received from #{sender[3]}:#{sender[1]}\n#{message}"
        parsed_message = Message.new(message)
        message_handlers.each do |handler|
          handler.handle parsed_message, sender
        end
      end

      attr_reader :ip
      attr_accessor :message_handlers
    end

  end

end
