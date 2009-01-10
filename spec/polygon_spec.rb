require File.expand_path(File.dirname(__FILE__) + "/spec_helper.rb") 
require 'polygon'

describe Polygon do
  before do
    @verts = [
      vec2(0,0),
      vec2(10,-15),
      vec2(-20,3)
    ]
    @poly = Polygon.new(@verts)
  end

  it "has vertices" do
    @poly.vertices.should == @verts
  end

  it "uses a safe copy of the verts" do
    orig = @verts.dup
    @verts.shift
    @verts[0] = vec2(4,4)
    @poly.vertices.should == orig
  end

  describe "when tampering with the vertices array" do
    it "prevents removal from the array" do
      assert_raise_frozen { @poly.vertices.shift }
    end

    it "prevents adding to the array" do
      assert_raise_frozen { @poly.vertices << vec2(0,0) }
    end

    it "prevents changing points in the array" do
      assert_raise_frozen { @poly.vertices.first.x = 5 }
    end
  end

  it "has a center" do
    @poly.center.should == vec2(-3.333, -4)
  end

  it "prevents direct tampering with the center" do
    assert_raise_frozen { @poly.center.x = 5 }
  end

  it "calculates bounds" do
    b = @poly.bounds 
    b.left.should == -20
    b.right.should == 10
    b.top.should == -15
    b.bottom.should == 3
  end

  it "prevents tampering with its bounds" do
    assert_raise_frozen { @poly.bounds.translate(ZeroVec2) }
    lambda { @poly.bounds.dup.translate(vec2(1,1)) }.should_not raise_error
  end

  it "can be translated" do
    @poly.translate(vec2(4,7))
    verts = @poly.vertices
    verts.first.should == (@verts.first + vec2(4,7))
    verts.last.should == (@verts.last + vec2(4,7))
  end

  it "recalcs the bounds when translated" do
    @poly.translate(vec2(4,7))
    b = @poly.bounds
    b.left.should == -16
    b.right.should == 14
    b.top.should == -8
    b.bottom.should == 10
  end

  it "returns self when translated" do
    @poly.translate(vec2(4,5)).should equal(@poly)
  end

  it "returns a self duplicate for to_polygon" do
    p2 = @poly.to_polygon
    p2.vertices.should == @poly.vertices
    p2.object_id.should_not == @poly.object_id
  end

  it "can be duplicated" do
    p2 = @poly.to_polygon
    p2.vertices.should == @poly.vertices
    p2.object_id.should_not == @poly.object_id
  end

  it "can be frozen" do
    @poly.freeze
    assert_raise_frozen { @poly.translate(ZeroVec2) }
  end

end
