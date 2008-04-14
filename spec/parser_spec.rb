$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
require File.expand_path(File.dirname(__FILE__) + '/../lib/jcon.rb')

describe JCON::Parser do
  describe :parse do
    it "should parse a basic type definition" do
      dict = JCON::Parser.parse('type S = string')
      type = dict[:S]
      type.should be_an_instance_of(JCON::Types::SimpleType)
    end
    
    it "should parse a basic type definition" do
      type = JCON::Parser.parse('type S = (string, String)')[:S]
      type.should be_an_instance_of(JCON::Types::UnionType)
    end
  end
end
