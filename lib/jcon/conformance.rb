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
  end
end
