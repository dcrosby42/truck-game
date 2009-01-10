require File.expand_path(File.dirname(__FILE__) + "/spec_helper.rb") 
require 'rectangle'

describe Rectangle do
  before do
    @rect = Rectangle.new(2,3,100,150)
  end

  it "has various accessors" do
    @rect.x.should == 2
    @rect.y.should == 3
    @rect.width.should == 100
    @rect.height.should == 150
    @rect.left.should == 2
    @rect.top.should == 3
    @rect.right.should == 102
    @rect.bottom.should == 153
    @rect.center.should == vec2(52,78)
  end

  it "prevents direct tampering with the center" do
    assert_raise_frozen { @rect.center.x = 6 }
  end

  it "is its own bounds" do
    @rect.bounds.should equal(@rect)
  end

  it "allows tampering with its bounds" do
    @rect.bounds.translate(vec2(10,10))
    @rect.bounds.x.should == 12
    @rect.x.should == 12
  end

  it "can be translated" do
    @rect.translate(vec2(10,10))
    @rect.x.should == 12
    @rect.y.should == 13
    @rect.width.should == 100
    @rect.height.should == 150
    @rect.left.should == 12
    @rect.top.should == 13
    @rect.right.should == 112
    @rect.bottom.should == 163
    @rect.center.should == vec2(62,88)
  end

  it "can be duplicated" do
    r = @rect.dup
    r.should_not equal(@rect)
    r.x.should == 2
    r.y.should == 3
    r.width.should == 100
    r.height.should == 150
  end

  it "can be frozen" do
    @rect.freeze
    assert_raise_frozen { @rect.translate(ZeroVec2) }
  end
end
