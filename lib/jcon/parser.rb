require 'strscan'

module JCON
  def self.parse(source)
    Parser.parse(source).start
  end
  
  class Parser < StringScanner
    include Types
    
    COMMENT = %r{//.*|/\*(?:.|[\r\n])*?\*/}
    WS_CHAR = /[\s\r\n]/
    IGNORE = /(?:#{COMMENT}|#{WS_CHAR})+/
    IDENTIFIER = /[\w_$][\w\d_$]*/

    def self.parse(source)
      self.new(source).parse
    end
    
    attr_reader :dictionary

    def initialize(source)
      super(source)
      @dictionary = Dictionary.new
    end

    def parse
      reset
      until eos?
        case
        when skip(IGNORE)
        when skip(/;/)
          ;
        when scan(/type/)
          parse_deftype
        else
          type = parse_type
          dictionary.start = type
          while skip(IGNORE) || skip(/;/); end
          parse_error "expected end of input" unless eos?  
        end
      end
      dictionary
    end
    
    def parse_deftype
      name = expect('identifier', IDENTIFIER)
      expect('=', /=/)
      type = parse_type
      dictionary.deftype(name.intern, type)
      sscan(/;/)
    end
    
    def parse_type
      skip(IGNORE)
      type = case
             when id = scan(IDENTIFIER)
               simple_type(id)
             when scan(/\*/)
               simple_type('*')
             when scan(/\[/)
               types = parse_types_until(/\]/)
               list(*types)
             when scan(/\(/)
               types = parse_types_until(/\)/)
               union(*types)
             when scan(/\{/)
               parse_structure_type
             else
               parse_error
             end
      type.context = dictionary
      add_modifiers(type)
    end
    
    def add_modifiers(type)
      while sscan(/[!?]/)
        case self[0]
        when '!'
          type = required(type)
        when '?'
          type = optional(type)
        end
        type.context = dictionary
      end
      type
    end
    
    def parse_types_until(stop_pattern)
      types = []
      while true
        break if sscan(stop_pattern)
        expect('comma', /,/) if types.any?
        types << parse_type
      end
      types
    end
    
    def parse_structure_type
      map = {}
      while true
        break if sscan(/\}/)
        expect('comma', /,/) if map.any?
        name = expect('id', IDENTIFIER)
        expect(':', /:/)
        type = parse_type
        map[name.intern] = type
      end
      RecordType.new(map)
    end
    
    def expect(name, pattern)
      value = sscan(pattern)
      parse_error("expected #{name}") unless value
      value
    end

    def sscan(pattern)
      skip(IGNORE)
      scan(pattern)
    end

    def parse_error(msg='unexpected token')
      raise "#{msg} at '#{skip(IGNORE); peek(20)}'"
    end
  end
end
