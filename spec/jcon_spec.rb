require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe JCON do
  describe :parse do
    it "parse should return a type" do
      type = JCON::parse('string')
      type.should be_an_instance_of(JCON::Types::SimpleType)
    end
  end
end
