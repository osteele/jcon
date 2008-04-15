require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe JCON::Matchers do
  include JCON::Matchers
  
  describe :conforms_to_js do
    it "should test basic types" do
      1.should conform_to_js('int')
      1.should_not conform_to_js('string')
      's'.should conform_to_js('string')
      's'.should_not conform_to_js('int')
      lambda { 1.should conform_to_js('string') }.should raise_error('should conform to type string, but did not')
      lambda { 1.should_not conform_to_js('int') }.should raise_error('should not conform to type int, but did')
    end
    
    it "should test nullability" do
      1.should conform_to_js('int')
      nil.should_not conform_to_js('int')
      1.should conform_to_js('Number')
      nil.should conform_to_js('Number')
      1.should conform_to_js('int!')
      nil.should_not conform_to_js('int!')
      1.should conform_to_js('Number!')
      nil.should_not conform_to_js('Number!')
      1.should conform_to_js('int?')
      nil.should conform_to_js('int?')
      1.should conform_to_js('Number?')
      nil.should conform_to_js('Number?')
    end
    
    it "should test more complex cases" do
      [[1], 2].should conform_to_js('[Array, (int, boolean)]')
      [[1], true].should conform_to_js('[Array, (int, boolean)]')
      [[1], 2, true].should conform_to_js('[Array, (int, boolean)]')
      [].should_not conform_to_js('[Array, (int, boolean)]')
      [1, 2].should_not conform_to_js('[Array, (int, boolean)]')
      [[1], nil].should_not conform_to_js('[Array, (int, boolean)]')
      
      pending { {'x' => 1, 'y' => 2, 'z' => 3}.should conform_to_js('{x: float, y: float, z: float?}') }
      #args.should conform_to_js('[[Array, (int, boolean)], {x: float, y: float, z: float?}]')
    end
  end
end