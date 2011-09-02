require 'skypekit_pure/errors'
require 'skypekit_pure/api'
require 'skypekit_pure/skype'
require 'skypekit_pure/version'

module SkypekitPure
  extend self
  
  def connect(ssl_key, host = '127.0.0.1', port = 8963)
    Skype.new(ssl_key, host, port)
  end
  
end