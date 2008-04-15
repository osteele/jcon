require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe JCON::Parser do
  describe :parse do
    it "should parse a bare type" do
      type = JCON::Parser.parse('string').start
      type.should be_an_instance_of(JCON::Types::SimpleType)
    end
    
    it "should parse a union type" do
      type = JCON::Parser.parse('(string, String)').start
      type.should be_an_instance_of(JCON::Types::UnionType)
      type.types.length.should == 2
      type.types[0].name.should == :string
      type.types[1].name.should == :String
    end
    
    it "should parse a list type" do
      type = JCON::Parser.parse('[string, String]').start
      type.should be_an_instance_of(JCON::Types::ListType)
      type.types.length.should == 2
      type.types[0].name.should == :string
      type.types[1].name.should == :String
    end
    
    it "should parse a required type" do
      type = JCON::Parser.parse('string!').start
      type.should be_an_instance_of(JCON::Types::RequiredType)
    end
    
    it "should parse an optional type" do
      type = JCON::Parser.parse('type T = string?')[:T]
      type.should be_an_instance_of(JCON::Types::OptionalType)
    end
    
    it "should parse a structure type" do
      type = JCON::Parser.parse('type T = {a:string?, b:int}')[:T]
      type.should be_an_instance_of(JCON::Types::StructureType)
    end
    
    it "should parse a basic type definition" do
      type = JCON::Parser.parse('type T = string')[:T]
      type.should be_an_instance_of(JCON::Types::SimpleType)
    end
    
    it "should parse two type definitions" do
      dict = JCON::Parser.parse('type T = string; type U = String;')
      dict.definitions.length.should == 2
      dict[:U].should be_an_instance_of(JCON::Types::SimpleType)
      dict[:T].should be_an_instance_of(JCON::Types::SimpleType)
    end
    
    it "should parse a union type definition" do
      type = JCON::Parser.parse('type T = (string, String)')[:T]
      type.should be_an_instance_of(JCON::Types::UnionType)
      type.types.length.should == 2
      type.types[0].name.should == :string
      type.types[1].name.should == :String
    end
    
    it "should ignore extraneous semicolons" do
      dict = JCON::Parser.parse(';type T = string')
      dict.definitions.length.should == 1
      dict = JCON::Parser.parse(';;type T = string')
      dict.definitions.length.should == 1
      dict = JCON::Parser.parse('type T = string;')
      dict.definitions.length.should == 1
      dict = JCON::Parser.parse('type T = string;;')
      dict.definitions.length.should == 1
      dict = JCON::Parser.parse('type T = string;type U = String;')
      dict.definitions.length.should == 2
      dict = JCON::Parser.parse(';;string;;')
      dict.start.should be_an_instance_of(JCON::Types::SimpleType)
    end
  end
  
  describe :start do
    it "should return the first definition" do
      type = JCON::Parser.parse('type T = string; type U = String;').start
      type.should be_an_instance_of(JCON::Types::SimpleType)
      type.name.should == :string
    end
  end
end
