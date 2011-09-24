require 'couchtrans'

describe Couchtrans::Ssdp::Message do

  it 'should parse a valid notify message ' do
    m = Couchtrans::Ssdp::Message.new("NOTIFY * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nNT: urn:schemas-upnp-org:service:RenderingControl:1\r\nNTS: ssdp:alive\r\nLOCATION: http://192.168.1.118:1026/\r\nUSN: uuid:10187569-1305-2000-0000-0022487457d9::urn:schemas-upnp-org:service:RenderingControl:1\r\nCACHE-CONTROL: max-age=1800\r\nSERVER: Xbox/2.0.20158.0 UPnP/1.0 Xbox/2.0.20158.0\r\n\r\n")

    m.meth.should == 'NOTIFY'

    m.headers.should == {
      'host'          => '239.255.255.250:1900',
      'nt'            => 'urn:schemas-upnp-org:service:RenderingControl:1',
      'nts'           => 'ssdp:alive',
      'location'      => 'http://192.168.1.118:1026/',
      'usn'           => 'uuid:10187569-1305-2000-0000-0022487457d9::urn:schemas-upnp-org:service:RenderingControl:1',
      'cache-control' => 'max-age=1800',
      'server'        => 'Xbox/2.0.20158.0 UPnP/1.0 Xbox/2.0.20158.0',
    }
  end

end
