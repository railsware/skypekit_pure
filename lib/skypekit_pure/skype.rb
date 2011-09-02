module SkypekitPure
  class Skype
    
    def initialize(ssl_key, host = '127.0.0.1', port = 8963)
      @api = Api.new({:ssl_key => ssl_key, :hostname => host, :port => port})
    end
    
    def disconnect
      @api.disconnect
    end
      
  end
end