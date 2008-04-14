require File.join(File.dirname(__FILE__), 'types')

module JCON
  class Dictionary
    include Types
    
    def initialize
      @definitions = {}
      add_builtin_definitions
    end
    
    def deftype(name, value)
      name = name.intern if name.is_a?(String)
      @definitions[name] = value
    end
    
    def [](name)
      @definitions[name]
    end

    def add_builtin_definitions
      deftype :AnyString, union(:string, String)
      deftype :AnyBoolean, union(:boolean, :Boolean) 
      deftype :AnyNumber, union(:byte, :int, :uint, :double, :decimal,:Number) 
      deftype :FloatNumber, union(:double, :decimal) 
    end
  end
end
