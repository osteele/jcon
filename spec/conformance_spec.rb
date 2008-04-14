require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe JCON do
  describe :conforms? do
    it "should test boolean types" do
      type = JCON::Parser.parse('type T = boolean').start
      type.contains?(false).should == true
      type.contains?(true).should == true
      type.contains?('s').should == false
      type.contains?(nil).should == false
      
      type = JCON::Parser.parse('type T = Boolean').start
      type.contains?(false).should == true
      type.contains?(true).should == true
      type.contains?('s').should == false
      type.contains?(nil).should == true
    end
    
    it "should test string types" do
      type = JCON::Parser.parse('type T = string').start
      type.contains?(1).should == false
      type.contains?('s').should == true
      type.contains?(nil).should == false
      
      type = JCON::Parser.parse('type T = String').start
      type.contains?(1).should == false
      type.contains?('s').should == true
      type.contains?(nil).should == true
    end
    
    it "should test numeric types" do
      type = JCON::Parser.parse('type T = Number').start
      type.contains?(1).should == true
      type.contains?('s').should == false
      type.contains?(nil).should == true
      
      type = JCON::Parser.parse('type T = int').start
      type.contains?(1).should == true
      type.contains?(1.5).should == false
      type.contains?('s').should == false
      type.contains?(nil).should == false
      
      type = JCON::Parser.parse('type T = uint').start
      type.contains?(1).should == true
      type.contains?(1.5).should == false
      type.contains?(-1).should == false
      type.contains?(nil).should == false
      
      type = JCON::Parser.parse('type T = double').start
      type.contains?(1).should == true
      type.contains?(1.5).should == true
      type.contains?(nil).should == false
      
      type = JCON::Parser.parse('type T = decimal').start
      type.contains?(1).should == true
      type.contains?(1.5).should == true
      type.contains?(nil).should == false
    end
    
    it "should test optional types" do
      type = JCON::Parser.parse('type T = int?').start
      type.contains?(1).should == true
      type.contains?(nil).should == true
    end
    
    it "should test required types" do
      type = JCON::Parser.parse('type T = Number!').start
      type.contains?(1).should == true
      type.contains?(nil).should == false
    end
    
    it "should test union types" do
      type = JCON::Parser.parse('type T = (string, boolean)').start
      type.contains?('s').should == true
      type.contains?(true).should == true
      type.contains?(1).should == false
      type.contains?(nil).should == false
    end
    
    it "should test list types" do
      type = JCON::Parser.parse('type T = [string, boolean]').start
      type.contains?('s').should == false
      type.contains?([]).should == false
      type.contains?([1]).should == false
      type.contains?([1,2]).should == false
      type.contains?([1,2,3]).should == false
      type.contains?(['s']).should == false
      type.contains?(['s',2]).should == false
      type.contains?([1,true]).should == false
      type.contains?(['s',true]).should == true
      type.contains?(['s',true,true]).should == true
      type.contains?(['s',true,3]).should == false
    end
    
    it "should test structure types" do
      type = JCON::Parser.parse('type T = {a:int, b:string}').start
      type.contains?('s').should == false
      type.contains?({:a => 1}).should == false
      type.contains?({:b => 's'}).should == false
      type.contains?({:a => 1, :b => 's'}).should == true
      type.contains?({:a => 's', :b => 's'}).should == false
      type.contains?({:a => 1, :b => 2}).should == false
      type.contains?({:a => 1, :b => 's', :c => false}).should == false
    end
    
    it "should test type null type"
  end
end
