require 'ipaddr'
require 'socket'

require 'guid'

require 'pp'

module Couchtrans

  module Ssdp
    MulticastIp = '239.255.255.250'
    Port = 1900

    class Server

      def initialize(ip)
        @ip = ip

        @http_port = 4150
        @uuid = Guid.new
      end

      def start
        socket = UDPSocket.new
        socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP,
          IPAddr.new(MulticastIp).hton + IPAddr.new(ip).hton)
        socket.bind Socket::INADDR_ANY, Port

        announce

        loop { handle_message(*socket.recvfrom(1024)) }
      end

      def announce
        common = {
          'cache-control' => 'max-age=60',
          'host' => "#{MulticastIp}:#{Port}",
          'location' => "http://#{ip}:#{http_port}/couchtrans",
          'nts' => 'ssdp:alive',
          'server' => "#{RUBY_PLATFORM}/0.0 UPnP/1.0 couchtrans/0.1",
        }

        message1 = Message.new
        message1.meth = 'notify'
        message1.headers = common.merge(
          'nt' => 'upnp:rootdevice',
          'usn' => "uuid:#{uuid}::upnp:rootdevice"
        )

        message2 = Message.new
        message2.meth = 'notify'
        message2.headers = common.merge(
          'nt' => "uuid:#{uuid}",
          'usn' => "uuid:#{uuid}"
        )

        message3 = Message.new
        message3.meth = 'notify'
        message3.headers = common.merge(
          'nt' => "urn:schemas-upnp-org:device:deviceType:ver",
          'usn' => "uuid:#{uuid}::urn:schemas-upnp-org:device:MediaServer:1"
        )

        begin
          socket = UDPSocket.open
          [message1, message2, message3].each do |m|
            socket.send m.to_s, 0, MulticastIp, Port
          end
        ensure
          socket.close 
        end
      end

      def handle_message(message, info)
        pp info
        pp Message.new(message)
      end

      attr_accessor :http_port

      attr_reader :ip
      attr_reader :uuid
    end

  end

end
