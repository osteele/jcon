require 'strscan'

module JCON
  class Parser < StringScanner
    include Types
    
    WS = /[\s]/
    IGNORE = %r{//.*|/\*[.\r\n]*?\*/}
    IDENTIFIER = /[\w_$][\w\d_$]*/

    def self.parse(source)
      self.new(source).parse
    end
    
    attr_reader :definitions

    def initialize(source)
      super(source)
      @definitions = Dictionary.new
    end

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
      sscan(/;/)
    end
    
    def parse_type
      type = case
             when id = sscan(IDENTIFIER)
               simple_type(id)
             when sscan(/\[/)
               types = parse_types_until(/\]/)
               list(types)
             when sscan(/\(/)
               types = parse_types_until(/\)/)
               union(types)
             when sscan(/\{/)
               parse_structure_type
             else
               parse_error
             end
      while sscan(/[!?]/)
        case self[0]
        when '!'
          type = required(type)
        when '?'
          type = optional(type)
        end
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
      StructureType.new(map)
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
