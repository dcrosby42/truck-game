class GameMaster 

  constructor :mode_wrangler, :game_config, :level_factory do
    @level_getters = @game_config.level_sequence.map do |lname|
      "get_#{lname}"
    end
  end

  def play_through_levels
    play_levels @level_getters.dup
  end

  private 

  def play_levels(level_getter_names)
    return if level_getter_names.empty?

    getter_name = level_getter_names.shift
    level = @level_factory.send(getter_name)

    @mode_wrangler.push level

    level.when :abort do
      @mode_wrangler.pop
      level.unsubscribe :abort, self
      level.unsubscribe :complete, self
    end

    level.when :complete do
      @mode_wrangler.pop
      level.unsubscribe :abort, self
      level.unsubscribe :complete, self
      play_levels level_getter_names
    end
  end

end
