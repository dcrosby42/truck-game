require 'joint_wrapper'

class JointFactory
  constructor :space_holder

  def new_groove(opts)
    joint = CP::Constraint::GrooveJoint.new(
      opts[:groove_on], opts[:attach_to],
      opts[:groove_start], opts[:groove_stop], opts[:groove_attach]
    )
    jw = JointWrapper.new(joint, @space_holder.space)
    jw.add_to_space if opts[:auto_add]
    jw
  end

  def new_pivot(opts)
    joint = CP::Constraint::PivotJoint.new(
      opts[:body_a],
      opts[:body_b],
      opts[:pivot_point],
      opts[:pivot_point]
    )
    jw = JointWrapper.new(joint, @space_holder.space)
    jw.add_to_space if opts[:auto_add]
    jw
  end

  def new_fastener(opts)
    a = opts[:body_a]
    b = opts[:body_b]
    pt = opts[:fasten_at_world]
    joint = CP::Constraint::PinJoint.new(a,b,
                                         a.world2local(pt), b.world2local(pt))
    jw = JointWrapper.new(joint, @space_holder.space)
    jw.add_to_space if opts[:auto_add]
    jw
    #   opts[:body_a],
    #   opts[:body_b],
    #   opts[:pivot_point],
    #   opts[:pivot_point]
    # )

  end
end
