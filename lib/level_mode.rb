require 'mode'

class LevelMode < Mode
  can_fire :complete, :abort

  def setup_level
    # override me
  end

  def complete_level
    fire :complete
  end

  def abort_level
    fire :abort
  end


end
