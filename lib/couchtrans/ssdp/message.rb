module Couchtrans

  module Ssdp

    Eol = "\r\n"
    StartLineRe = %r{^(?:(NOTIFY|M-SEARCH) \* HTTP/1.1|HTTP/1.1 200 (OK))$}i
    HeaderRe = %r{^(?<k>[a-z\-]+): (?<v>.*)$}i

    class Message

      def initialize(s); parse(s); end

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

      attr_reader :meth
      attr_reader :headers
    end

  end

end
