require 'strscan'

module JCON
  class Parser < StringScanner
    IDENTIFIER = /[\w_$][\w\d_$]*/
    WS = /[\s]/
    IGNORE = %r{//.*|/\*[.\r\n]*?\*/}

    def self.parse(source)
      self.new(source).parse
    end

    
    def initialize(source)
      super(source)
      @definitions = TypeCollection.new
    end

    attr_reader :definitions

    def parse
      reset
      until eos?
        case
        when sscan(/type/)
          parse_deftype
        when skip(IGNORE)
          ;
        else
          parse_error
        end
      end
      definitions
    end
    
    def parse_deftype
      name = expect('identifier', IDENTIFIER)
      expect('=', /=/)
      type = parse_type
      definitions.deftype(name.intern, type)
    end
    
    def parse_type
      case
      when id = sscan(IDENTIFIER)
        return id
      else
        parse_error
      end        
    end
    
    def expect(name, pattern)
      value = sscan(pattern)
      parse_error("expected #{name}") unless value
      value
    end

    def sscan(pattern)
      skip(WS)
      scan(pattern)
    end

    def parse_error(msg='unexpected token')
      raise "#{msg} at '#{skip(WS); peek(20)}'"
    end
  end
end
