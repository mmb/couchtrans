require 'logger'
require 'time'

module Couchtrans

  module Logged

    MultilineSep = '-' * 80
    Eol = "\n"

    def log
      if instance_variable_defined? :@log
        @log
      else
        new_log = Logger.new($stdout)
        new_log.formatter = proc do |severity, datetime, progname, msg|
          if msg.index(Eol)
            msg = "multiline message:#{Eol}#{MultilineSep}#{Eol}#{msg}#{Eol}#{MultilineSep}"
          end
          "#{datetime.iso8601} #{severity} #{self.class} - #{msg}#{Eol}"
        end
        @log = new_log
      end
    end

    attr_writer :log
  end

end
