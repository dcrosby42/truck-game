class AppStarter
  constructor :main_window, :main_menu_mode, :mode_wrangler, :debug_server, :game_master

  def run
#    @mode_wrangler.push(@main_menu_mode)
    @game_master.play_through_levels

    @debug_server.start
    @main_window.show
  end

end
