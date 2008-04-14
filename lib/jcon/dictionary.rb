require File.join(File.dirname(__FILE__), 'types')

module JCON
  class Dictionary
    include Types
    
    attr_reader :start
    
    def initialize
      @definitions = {}
      add_builtin_definitions
    end
    
    def deftype(name, type)
      name = name.intern if name.is_a?(String)
      @definitions[name] = type
      @start ||= type
    end
    
    def [](name)
      @definitions[name]
    end

    def add_builtin_definitions
      saved_start = @start
      deftype :AnyString, union(:string, String)
      deftype :AnyBoolean, union(:boolean, :Boolean) 
      deftype :AnyNumber, union(:byte, :int, :uint, :double, :decimal,:Number) 
      deftype :FloatNumber, union(:double, :decimal) 
      @start = saved_start
    end
  end
end
