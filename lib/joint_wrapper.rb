class JointWrapper
  def initialize(joint, space)
    @space = space
    @joint = joint
    @added = false
  end

  def add_to_space
    @space.add_joint(@joint) unless @added
    @added = true
  end

  def remove_from_space
    @space.remove_joint(@joint) if @added
    @added = false
  end

  def added_to_space?
    @added
  end
end
