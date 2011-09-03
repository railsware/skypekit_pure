module SkypekitPure
  class Request
    
    def initialyze
      @tokens = ['B']
      @encoders = {}
      @encoders['i'] = encode_varint
      @encoders['u'] = encode_varuint
      @encoders['e'] = encode_varuint
      @encoders['o'] = encode_varuint
      @encoders['O'] = encode_objectid
      @encoders['S'] = encode_string
      @encoders['X'] = encode_string
      @encoders['f'] = encode_string
      @encoders['B'] = encode_string
    end
    
    def add_parm(kind, tag, val)
      if val.is_a?(Hash)
        @tokens << ord_method('[')
        self.encode_varuint(tag)
        encoder = @encoders[kind]
        val.each do |elem|
          if kind != 'b'
            @tokens << ord_method(kind)
            #encoder(self, elem)
          else
            if elem
              @tokens << ord_method('T')
            else
              @tokens << ord_method('F')
            end
          end
        end
        @tokens << ord_method(']')
      elsif kind != 'b'
        @tokens << ord_method(kind)
        if tag == 0
          @oid = val.object_id
        end
        self.encode_varuint(tag)
        #@encoders[kind](self, val)
      else
        if val
          @tokens << ord_method('T')
        else
          @tokens << ord_method('F')
        end
        self.encode_varuint(tag)
      end
      self
    end
    
    private
    
    def encode_varint(number)
      if number >= 0
        number = number << 1
      else
        number = (number << 1) ^ (~0)
      end
      self.encode_varuint(number)
    end
    
    def encode_varuint(number)
      while 1 do
        towrite = number & 0x7f
        number = number >> 7
        if number == 0
          @tokens << towrite
          break
        end
        @tokens << (0x80|towrite)
      end
    end
    
    def encode_objectid(val)
      unless val
        self.encode_varuint(0)
      else
        self.encode_varuint(val.object_id)
      end
    end
    
    def encode_objectid(val)
      length = val.length
      self.encode_varuint(length)
      if length > 0
        @tokens += split("").map{|a| ord_method(a) }
      end
    end
    
    def ord_method(str)
      str.respond_to?('ord') ? str.ord : str.unpack('c')[0]
    end
    
  end
end 