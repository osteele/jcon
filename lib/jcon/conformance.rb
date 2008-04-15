module JCON
  module Types
    class SimpleType < Type
      def contains?(value)
        if not @test and context and@context[name]
          return context[name].contains?(value)
        end
        raise "No definition for #{self}" unless @test
        @test.call(value)
      end
    end
    
    class OptionalType < Type
      def contains?(value)
        value.nil? or type.contains?(value)
      end
    end
    
    class RequiredType < Type
      def contains?(value)
        !value.nil? and type.contains?(value)
      end
    end
    
    class ListType < Type
      def contains?(value)
        return false unless value.is_a?(Array)
        return false unless value.length >= types.length
        value.each_with_index do |x, i|
          return false unless types[[i, types.length-1].min].contains?(x)
        end
        true
      end
    end
    
    class UnionType < Type
      def contains?(value)
        types.any? do |type| type.contains?(value) end
      end
    end
    
    class StructureType < Type
      def contains?(value)
        return false unless value.is_a?(Hash)
        value.each do |k, v|
          type = properties["#{k}".intern]
          return false unless type
          return false unless type.contains?(v)
        end
        properties.each do |k, _|
          return false unless value.include?(k) or value.include?(k.to_s)
        end
        true
      end
    end
  end
end
