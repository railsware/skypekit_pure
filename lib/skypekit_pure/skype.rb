module SkypekitPure
  class Skype
    
    def initialize(ssl_key, host = '127.0.0.1', port = 8963)
      @api = Api.new({:ssl_key => ssl_key, :hostname => host, :port => port})
    end
    
    def disconnect
      @api.disconnect
    end
    
    def get_account
      #l_request = skypekit.XCallRequest("ZR\000s", 0, 115)
      #l_request.add_parm('S', 1, identity)
      #l_response = self.transport.xcall(l_request)
      #l_result = module_id2classes[5](l_response.get(1), self.transport)
    end
      
  end
end