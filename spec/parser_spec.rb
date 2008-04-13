$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
require File.expand_path(File.dirname(__FILE__) + '/../lib/jcon.rb')

describe JCON::Parser do
  describe :parse do
    it "it runs" do
      p JCON::Parser.parse('type S = string')
      # int {a:string} (string,int) (string,null) string? string!
    end
  end
end
