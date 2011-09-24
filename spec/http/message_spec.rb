require 'couchtrans'

describe Couchtrans::Http::Message do

  it 'should parse valid HTTP' do
    m = Couchtrans::Http::Message.new("NOTIFY * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nNT: urn:schemas-upnp-org:service:RenderingControl:1\r\nNTS: ssdp:alive\r\nLOCATION: http://192.168.1.118:1026/\r\nUSN: uuid:10187569-1305-2000-0000-0022487457d9::urn:schemas-upnp-org:service:RenderingControl:1\r\nCACHE-CONTROL: max-age=1800\r\nSERVER: Xbox/2.0.20158.0 UPnP/1.0 Xbox/2.0.20158.0\r\n\r\n")

    m.meth.should == 'NOTIFY'
    m.uri.should == '*'
    m.version.should == '1.1'

    m.headers.should == {
      'HOST'          => '239.255.255.250:1900',
      'NT'            => 'urn:schemas-upnp-org:service:RenderingControl:1',
      'NTS'           => 'ssdp:alive',
      'LOCATION'      => 'http://192.168.1.118:1026/',
      'USN'           => 'uuid:10187569-1305-2000-0000-0022487457d9::urn:schemas-upnp-org:service:RenderingControl:1',
      'CACHE-CONTROL' => 'max-age=1800',
      'SERVER'        => 'Xbox/2.0.20158.0 UPnP/1.0 Xbox/2.0.20158.0',
    }

    m.body.should be_empty
  end

end
