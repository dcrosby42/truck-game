class LevelFactory
  constructor :system_context, :debug_server, :media_loader

  def get_workshop
    @system_context.within :workshop do |sub_context|
      mode = sub_context[:mode]
      mode.setup_level
      sub_context.build_everything
      @debug_server.level_context = sub_context
      mode
    end
  end

  def get_truck_level_1
    @system_context.within :truck_level_1 do |sub_context|
      mode = sub_context[:mode]
      mode.setup_level
      sub_context.build_everything
      @debug_server.level_context = sub_context
      mode
    end
  end

end 
