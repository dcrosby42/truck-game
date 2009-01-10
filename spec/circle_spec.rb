require File.expand_path(File.dirname(__FILE__) + "/spec_helper.rb") 
require 'circle'

describe Circle do
  before do
    @center = vec2(30,12)
    @radius = 5
    @circle = Circle.new(@center, @radius)
  end

  it "has center and radius accessors" do
    @circle.radius.should == @radius
    @circle.center.x.should == @center.x
    @circle.center.y.should == @center.y
  end

  it "calculates bounds" do
    @circle.bounds.should_not be_nil
    @circle.bounds.should be_an_instance_of(Rectangle)
    @circle.bounds.left.should == 25
    @circle.bounds.top.should == 7
    @circle.bounds.right.should == 35
    @circle.bounds.bottom.should == 17
    @circle.bounds.center.x.should == @center.x
    @circle.bounds.center.y.should == @center.y
  end

  it "uses a copy of the given centerpoint to avoid conflicts with outside mods" do
    @center.x = 44
    @center.y = 3000
    @circle.center.x.should == 30
    @circle.center.y.should == 12
  end

  it "prevents tampering with its center point" do
    lambda { @circle.center.x = 10 }.should raise_error(TypeError,/frozen/)
    lambda { @circle.center.y = 10 }.should raise_error(TypeError,/frozen/)
  end

  it "prevents tampering with its bounds" do
    lambda { @circle.bounds.translate(vec2(1,1)) }.should raise_error(TypeError,/frozen/)
    lambda { @circle.bounds.bounds.translate(vec2(1,1)) }.should raise_error(TypeError,/frozen/)
    # dup should be ok
    lambda { @circle.bounds.dup.translate(vec2(1,1)) }.should_not raise_error
  end

  it "can be translated" do 
    pt = vec2(50,60)
    @circle.translate(pt)
    @circle.center.x.should == 80
    @circle.center.y.should == 72
    @circle.radius.should == @radius
  end

  it "recalcs the bounds when translated" do
    pt = vec2(50,-20)
    @circle.translate(pt)
    @circle.bounds.left.should == 75
    @circle.bounds.top.should == -13
    @circle.bounds.right.should == 85
    @circle.bounds.bottom.should == -3
    @circle.bounds.center.x.should == 80
    @circle.bounds.center.y.should == -8
  end

  it "can be converted to a polygon" do
    poly = @circle.to_polygon
    poly.should_not be_nil
    poly.should have(10).vertices

    poly.vertices[0].x.should == 35
    poly.vertices[0].y.should == 12

    poly.vertices[5].x.should == 25
    poly.vertices[5].y.should == 12

#    ( 35.000,  12.000)
#    ( 34.045,  14.939)
#    ( 31.545,  16.755)
#    ( 28.455,  16.755)
#    ( 25.955,  14.939)
#    ( 25.000,  12.000)
#    ( 25.955,  9.061)
#    ( 28.455,  7.245)
#    ( 31.545,  7.245)
#    ( 34.045,  9.061)
  end

  it "yields a frozen polygon which cannot be tampered with" do
    poly = @circle.to_polygon
    lambda { poly.translate(vec2(1,1)) }.should raise_error(TypeError,/frozen/)
    # but the dup should be ok
    lambda { poly.dup.translate(vec2(1,1)) }.should_not raise_error
  end

  it "can be duplicated" do
    c = @circle.dup
    c.center.x.should == @circle.center.x
    c.center.y.should == @circle.center.y
    c.radius.should == @circle.radius
    c.should_not be_equal(@circle)
  end
end
