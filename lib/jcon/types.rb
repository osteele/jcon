module JCON
  module Types
    def self.to_type(value)
      value = SimpleType.new(value) unless value.is_a?(Type)
      value
    end
    
    def self.to_types(values)
      values.map { |value| to_type(value) }
    end
    
    class Type
      def inspect; to_s; end
    end
    
    class SimpleType < Type
      def initialize(name)
        name = name.intern if name.is_a?(String)
        @name = name
      end
      
      def to_s; @name.to_s; end
    end
    
    class OptionalType < Type
    end
    
    class RequiredType < Type
    end
    
    class ListType < Type
    end
    
    class UnionType < Type
      attr_reader :types
      
      def initialize(*types)
        @types = Types.to_types(types)
      end
      
      def to_s
        "(#{types.join(', ')})"
      end
    end
    
    def simple_type(*args); SimpleType.new(*args); end
    def union(*args); UnionType.new(*args); end
  end
end
