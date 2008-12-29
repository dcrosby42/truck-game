class YardController
  constructor :mode, :media_loader, :screen_info, :space_holder, :yard_ground, :heads_up do
    @bg_music = @media_loader.load_song("chariots.s3m")

    @mode.on :start do
      @heads_up.show_notice "This level under construction :(", 10
    end

    @mode.on :update do |info|
      @space_holder.step
      @bg_music.play unless @bg_music.playing?
    end

    @mode.on :draw do |info| 
      @yard_ground.draw
    end

    @mode.on :button_down do |id,info|
      if id == Gosu::KbEscape
        @mode.abort_level
      end
      if id == Gosu::KbF1
        @mode.complete_level
      end
    end

    @mode.on :stop do
      @bg_music.stop if @bg_music
    end
  end

end

