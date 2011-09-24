module Couchtrans

  module Http

    Eol = "\r\n"
    StartLineRe =
      /^([a-z]+) ([a-z0-9_.~!*'();:@&=+$,\/?#\[\]\-]+) HTTP\/([\d.]+)$/i
    HeaderRe = /^(?<k>[a-z\-]+): (?<v>.+)$/i

    # HTTP message parser
    class Message

      def initialize(s); parse(s); end

      def reset
        @meth = nil
        @uri = nil
        @version = nil
        @headers = {}
        @body = nil
      end

      def parse(s)
        reset

        s.each_line(Eol) do |line|
          line.chomp! Eol
          if not @meth
            if match = StartLineRe.match(line)
              @meth, @uri, @version = match.captures
            end
          elsif line.empty?
            @body = ''
          elsif @body
            @body << Eol  unless body.empty?
            @body << line
          else
            if match = HeaderRe.match(line)
              k, v = match.captures
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
      attr_reader :uri
      attr_reader :version
      attr_reader :headers
      attr_reader :body
    end

  end

end
