module Couchtrans

  module Ssdp

    Eol = "\r\n"
    StartLineRe = %r{^(?:(NOTIFY|M-SEARCH) \* HTTP/1.1|HTTP/1.1 200 (OK))$}i
    HeaderRe = %r{^([a-z.\-]+): *(.*)$}i

    class Message

      def initialize(s=nil)
        parse(s)  if s
      end

      def reset
        @meth = nil
        @headers = {}
      end

      def parse(s)
        reset

        s.each_line(Eol) do |line|
          line.chomp! Eol
          if not @meth
            if match = StartLineRe.match(line)
              @meth = match[1]
            end
          elsif line.empty?
            return
          else
            if match = HeaderRe.match(line)
              k, v = match.captures
              k.downcase!
              if @headers.key? k
                @headers[k] << ',' << v
              else
                @headers[k] = v
              end
            end
          end
        end
      end

      def to_s
        lines = [@meth == 'OK' ? 'HTTP/1.1 200 OK' :
          "#{@meth.upcase} * HTTP/1.1"]
        lines.push(*headers.to_a.map { |k,v| "#{k.upcase}: #{v}" })
        lines.join(Eol) << Eol * 2
      end

      attr_accessor :meth
      attr_accessor :headers
    end

  end

end
