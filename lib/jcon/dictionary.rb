require File.join(File.dirname(__FILE__), 'types')

module JCON
  class Dictionary
    include Types
    
    attr_reader :parent
    attr_accessor :start
    
    def initialize(parent=BUILTINS)
      @parent = parent
      @definitions = {}
    end
    
    def deftype(name, type=nil, &block)
      return deftype(name, SimpleType.new(name, &block)) if block
      case type
      when nil
        deftype(name, Kernel.const_get(name))
      when Class
        deftype(name) do |x| x.nil? or x.is_a?(type) end
      when Array
        deftype(name) do |x| type.include?(x) end
      when Type
        name = name.intern if name.is_a?(String)
        @definitions[name] = type
        @start ||= type
      else
        raise "invalid arguments"
      end
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
    
    def add_builtin_definitions
      deftype(:Object) do true end
      deftype(:Array)
      deftype(:Date)
      deftype(:RegExp, Regexp)
      deftype(:Boolean, [false,true,nil])
      deftype(:String)
      deftype(:Number, Numeric)
      deftype(:boolean, [false,true])
      deftype(:string) do |value| value.is_a?(String) end
      deftype(:int) do |value| value.is_a?(Integer) end
      deftype(:uint) do |value| value.is_a?(Integer) and value > 0 end
      deftype(:double) do |value| value.is_a?(Numeric) end
      deftype(:decimal) do |value| value.is_a?(Numeric) end
      deftype :AnyString, union(:string, String)
      deftype :AnyBoolean, union(:boolean, :Boolean) 
      deftype :AnyNumber, union(:byte, :int, :uint, :double, :decimal,:Number) 
      deftype :FloatNumber, union(:double, :decimal) 
    end
  end
  
  BUILTINS = DefaultDictionary.new
end
