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
        raise "pending"
      end
    end
    
    class UnionType < Type
      def contains?(value)
        types.any? do |type| type.contains?(value) end
      end
    end
    
    class StructureType < Type
      def contains?(value)
        raise "pending"
      end
    end
  end
end
