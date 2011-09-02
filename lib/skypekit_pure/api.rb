require 'socket'
require 'openssl'
require 'timeout'

module SkypekitPure
  class Api
    # ssl key
    attr_accessor :ssl_key
    # hostname
    attr_accessor :host
    # port
    attr_accessor :port
    
    # secret for skypekit
    SKYPEKIT_SECRET = "SkypeKit/SubscribedProperties=10:155,10:154,10:151,10:152,10:153,2:202,2:4,2:6,2:5,2:7,2:8,2:9,2:10,2:11,2:12,2:13,2:14,2:15,2:16,2:17,2:18,2:37,2:26,2:205,2:27,2:36,2:19,2:28,2:29,2:182,2:183,2:20,2:25,2:35,2:34,2:21,2:22,2:23,2:33,2:180,2:39,2:41,2:184,2:185,2:186,2:187,2:188,2:189,2:42,1:200,19:930,19:931,19:932,19:933,19:934,19:935,19:936,19:943,19:938,19:948,19:939,19:941,19:942,19:947,19:949,19:950,19:951,19:952,19:953,19:954,18:972,18:902,18:918,18:974,18:996,18:920,18:921,18:925,18:924,18:927,18:928,18:973,18:975,18:976,18:977,18:970,18:971,18:979,18:981,18:915,18:903,18:904,18:919,18:922,18:906,18:907,18:909,18:980,18:910,18:911,18:913,18:914,9:960,9:120,9:122,9:123,9:792,9:790,9:121,9:961,9:962,9:968,9:222,9:223,9:963,9:964,9:127,9:125,9:966,9:126,9:982,11:130,11:131,11:132,11:133,11:134,11:1104,11:1105,7:100,7:101,7:102,7:103,7:104,7:105,7:106,7:107,7:108,7:109,7:830,7:831,12:190,12:191,12:192,12:48,12:198,12:193,12:49,12:194,12:199,12:195,12:196,12:197,12:840,6:80,6:81,6:82,6:83,6:84,6:85,6:86,6:87,6:88,6:89,6:90,6:91,6:92,6:93,6:98,5:70,5:71,5:73,5:78,5:72,5:74,5:75,5:804,5:76,5:79,5:77,5:160,5:161,5:162,5:163,5:164,5:165,5:166,5:168,5:169,5:773,5:800,5:801,5:802,5:4,5:5,5:7,5:8,5:9,5:10,5:11,5:12,5:13,5:14,5:15,5:16,5:17,5:18,5:19,5:26,5:27,5:28,5:34,5:37,5:182,5:183,5:205\nSkypeKit/SubscribedEvents=10:1,10:2,0:1,0:2,0:3,1:1,19:1,18:1,18:2,18:3,0:4,0:5,11:2,11:1,0:7,0:10,0:11,0:12,0:6,0:8\n"
    
    def initialize(args)
      raise StandardError, "not set ssl_key" unless args[:ssl_key]
      self.ssl_key    = args[:ssl_key]
      self.host       = args[:hostname] || '127.0.0.1'
      self.port       = args[:port] || 8963
      retry_count = 3
      begin
        tcp_socket = TCPSocket.new(self.host, self.port)
      rescue Exception => e
        sleep 0.5
        retry_count -= 1
        raise if retry_count <= 0
        retry
      end
      ssl_context = OpenSSL::SSL::SSLContext.new(:TLSv1)
      ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(self.ssl_key))
      ssl_context.key = OpenSSL::PKey::RSA.new(File.open(self.ssl_key))
      ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @socket = OpenSSL::SSL::SSLSocket.new(tcp_socket, ssl_context)
      @socket.sync_close = true
      
      begin 
          timeout(5) do
              @socket.accept
          end
      rescue Timeout::Error
          raise ConnectionClosed, "error with accept connection"
      end
      
      handshake
    end
    
    def socket
      @socket
    end
    
    def handshake
      req = sprintf("%08x", SKYPEKIT_SECRET.length) + SKYPEKIT_SECRET                                                                                                                                                                 
      socket.write(req)
      data = self.read_bytes(2) 
      raise ConnectionClosed, "error with handshake" if 'OK' != data
    end
    
    def read_bytes(num_bytes = 1)
      data = ""
      while data.length < num_bytes
        begin
          timeout(3) do
            begin
              data += socket.respond_to?('read_nonblock') ? socket.read_nonblock(4096) : socket.sysread(4096)
            rescue OpenSSL::SSL::SSLError => e 
              sleep 0.1
              retry
            rescue
              raise ConnectionClosed, "error read data"
            end
          end
        rescue Timeout::Error
          raise ConnectionClosed, "error with accept connection"
        end
      end
      data[0..num_bytes-1]
    end
    
    def disconnect
      socket.close
    end
    
  end
end
