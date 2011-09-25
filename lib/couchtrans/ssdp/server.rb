require 'ipaddr'
require 'socket'

require 'guid'

module Couchtrans

  module Ssdp
    MulticastIp = '239.255.255.250'
    Port = 1900

    class Server

      def initialize
        @uuid = Guid.new
      end

      def start
        socket = UDPSocket.new
        socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP,
          IPAddr.new(MulticastIp).hton + IPAddr.new('0.0.0.0').hton)
        socket.bind Socket::INADDR_ANY, Port

        announce

        loop do
          puts socket.recvfrom(1024)
        end
      end

      def announce
        message = Message.new
        message.meth = 'notify'
        message.headers = {
          'nt' => 'upnp:rootdevice',
          'usn' => "uuid:#{uuid}::upnp:rootdevice",
          'location' => 'http://192.168.1.3:2869/couchtrans',
          'cache-control' => 60,
        }

        begin
          socket = UDPSocket.open
          socket.send message.to_s, 0, MulticastIp, Port
        ensure
          socket.close 
        end
      end

      attr_reader :uuid
    end

  end

end
