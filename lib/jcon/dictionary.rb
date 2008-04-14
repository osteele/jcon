require File.join(File.dirname(__FILE__), 'types')

module JCON
  class Dictionary
    include Types
    
    attr_reader :start, :parent
    
    def initialize(parent=BUILTINS)
      @parent = parent
      @definitions = {}
    end
    
    def deftype(name, type)
      name = name.intern if name.is_a?(String)
      @definitions[name] = type
      @start ||= type
    end
    
    def [](name)
      @definitions[name] || (parent && parent[name])
    end
  end
  
  class DefaultDictionary < Dictionary
    def initialize
      super(nil)
      add_builtin_definitions
    end
    
    def define_builtin(name, &block)
      deftype name, SimpleType.new(name, &block)
    end
    
    def add_builtin_definitions
      define_builtin(:Boolean) do |value| [false,true,nil].include?(value) end
      define_builtin(:String) do |value| value.nil? or value.is_a?(String) end
      define_builtin(:Number) do |value| value.nil? or value.is_a?(Numeric) end
      define_builtin(:boolean) do |value| [false,true].include?(value) end
      define_builtin(:string) do |value| value.is_a?(String) end
      define_builtin(:int) do |value| value.is_a?(Integer) end
      define_builtin(:uint) do |value| value.is_a?(Integer) and value > 0 end
      define_builtin(:double) do |value| value.is_a?(Numeric) end
      define_builtin(:decimal) do |value| value.is_a?(Numeric) end
      deftype :AnyString, union(:string, String)
      deftype :AnyBoolean, union(:boolean, :Boolean) 
      deftype :AnyNumber, union(:byte, :int, :uint, :double, :decimal,:Number) 
      deftype :FloatNumber, union(:double, :decimal) 
    end
  end
  
  BUILTINS = DefaultDictionary.new
end
