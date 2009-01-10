require 'joint_wrapper'

class JointFactory
  constructor :space_holder

  def new_groove(opts)
    joint = CP::Joint::Groove.new(
      opts[:groove_on], opts[:attach_to],
      opts[:groove_start], opts[:groove_stop], opts[:groove_attach]
    )
    jw = JointWrapper.new(joint, @space_holder.space)
    jw.add_to_space if opts[:auto_add]
    jw
  end

  def new_pivot(opts)
    joint = CP::Joint::Pivot.new(
      opts[:body_a],
      opts[:body_b],
      opts[:pivot_point]
    )
    jw = JointWrapper.new(joint, @space_holder.space)
    jw.add_to_space if opts[:auto_add]
    jw
  end
end
