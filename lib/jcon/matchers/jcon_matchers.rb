module JCON
  module Matchers
    class ConformToJSType #:nodoc:
      def initialize(type_or_text)
        type = type_or_text
        type = JCON.parse(type) if String === type
        @expected = type
      end
      
      def matches?(actual)
        @expected.contains?(actual)
      end

      def failure_message; "should #{description}, but did not"; end
      def negative_failure_message; "should not #{description}, but did"; end

      def description
        "conform to type #{@expected}"
      end
    end
    
    def conform_to_js(type_or_text)
      return ConformToJSType.new(type_or_text)
    end
  end
end
