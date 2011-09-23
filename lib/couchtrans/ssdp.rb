require 'ipaddr'
require 'socket'

module Couchtrans

  module Ssdp
    MulticastIp = '239.255.255.250'
    MulticastPort = 1900

    HttpVersion = 'HTTP/1.1'
    Terminator = "\r\n"

    class Server

      def initialize(ip=nil, port=nil)
        @ip = ip || MulticastIp
        @port = port || MulticastPort
      end

      def start
        socket = UDPSocket.new
        socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP,
          IPAddr.new(ip).hton + IPAddr.new('0.0.0.0').hton)
        socket.bind(Socket::INADDR_ANY, port)

        Ssdp.announce

        loop do
          puts socket.recvfrom(1024)
        end
      end

      attr_reader :ip
      attr_reader :port
    end

    module_function

    def announce(ip=nil, port=nil)
      begin
        socket = UDPSocket.open
        socket.send(notify_message, 0, ip || MulticastIp, port || MulticastPort)
      ensure
        socket.close 
      end
    end

    def message(message); [message, Terminator].join; end

    def notify_message; message("NOTIFY * #{HttpVersion}"); end

  end

end
