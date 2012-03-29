VERSION = '0.0.1'
SERVER_HEADER = "#{RUBY_PLATFORM}/0.0 UPnP/1.0 couchtrans/#{VERSION}"

require 'couchtrans/logged'

require 'couchtrans/ssdp/message'
require 'couchtrans/ssdp/server'
require 'couchtrans/ssdp/search_message_handler'
