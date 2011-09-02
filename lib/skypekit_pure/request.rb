module SkypekitPure
  class Request
    
    def initialyze
      @tokens = ['B']
      @encoders = {}
    end
    
    def add_parm(kind, tag, val)
      token = self.tokens
      if val.is_a?(Hash)
        token << ord_method('[')
        self.encode_varuint(tag)
        encoder = @encoders[kind]
        val.each do |elem|
          if kind != 'b'
            token << ord_method(kind)
            #encoder(self, elem)
          else
            if elem
              token << ord_method('T')
            else
              token << ord_method('F')
            end
          end
        end
        token << ord_method(']')
      elsif kind != 'b'
        token << ord_method(kind)
        if tag == 0
          @oid = val.object_id
        end
        self.encode_varuint(tag)
        #@encoders[kind](self, val)
      else
        if val
          token << ord_method('T')
        else
          token << ord_method('F')
        end
        self.encode_varuint(tag)
      end
      self
    end
    
    private
    
    def encode_varint(number)
      if number >= 0
        number *= 2
      else
        number = -2 * number - 1
      end
      self.encode_varuint(number)
      @encoders['i'] = encode_varint
    end
    
    def ord_method(str)
      str.respond_to?('ord') ? str.ord : str.unpack('c')[0]
    end
    
  end
end