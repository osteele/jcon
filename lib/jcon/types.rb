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
      attr_reader :type
      def initialize(type); @type = type; end
      def to_s; "#{type}?"; end
    end
    
    class RequiredType < Type
      attr_reader :type
      def initialize(type); @type = type; end
      def to_s; "#{type}!"; end
    end
    
    class ListType < Type
      attr_reader :types
      
      def initialize(*types)
        @types = Types.to_types(types)
      end
      
      def to_s
        "[#{types.join(', ')}]"
      end
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
    def required(*args); RequiredType.new(*args); end
    def optional(*args); OptionalType.new(*args); end
    def list(*args); ListType.new(*args); end
    def union(*args); UnionType.new(*args); end
  end
end
