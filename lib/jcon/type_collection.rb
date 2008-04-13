module JCON
  class TypeCollection
    def initialize
      @definitions = {}
      add_builtin_definitions
    end
    
    def deftype(name, value)
      @definitions[name] = value
    end
    
    def add_builtin_definitions
      # type AnyString = (string,String) 
      # type AnyBoolean = (boolean,Boolean) 
      # type AnyNumber = (byte,int,uint,double,decimal,Number) 
      # type FloatNumber = (double,decimal) 
    end
  end
end
