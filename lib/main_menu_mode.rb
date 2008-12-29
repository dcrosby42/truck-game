class MainMenuMode < BaseMode

  constructor :game_master, :media_loader, :main_window do
#    @bg_image = @media_loader.load_image("title-screen.png")

    @notice_font = @media_loader.load_default_font(50)
    @notice_color = 0xffffffff
    @notice_shadow_color = 0xaa000000

#    @bg_music = @media_loader.load_song("bladerun.mod")
  end

  def update(info)
#    @bg_music.play unless @bg_music.playing?
  end

  def stop
#    @bg_music.stop
  end

  def draw(info)
#    @bg_image.draw(0,0, ZOrder::Background)

    nx = info.screen_width / 2
    ny = info.screen_height / 2 + 200
    @notice_font.draw_rel("Press SPACE to Start",
                         nx + 5, ny + 7, ZOrder::GuiText,
                         0.5, 0.5,
                         1,1,
                         @notice_shadow_color)
    @notice_font.draw_rel("Press SPACE to Start",
                         nx, ny, ZOrder::GuiText,
                         0.5, 0.5,
                         1,1,
                         @notice_color)
  end

  def button_down(id,info)
    if Gosu::KbEscape == id
      @main_window.close
    end
    if Gosu::KbSpace == id
      @game_master.play_through_levels
    end
  end

end
