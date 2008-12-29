
class FieldController

  constructor :field_model, :mode, :tractor, :heads_up do
    @items = []
    @total_score = 0

    @mode.on :start do
      @heads_up.show_notice(@field_model.goal_description, 5)
    end

    @mode.on :update do |info|
      add_item_if_needed info
      collect_items_near_tractor
      check_for_done
    end

    @mode.on :button_down do |id,info|
      if id == Gosu::KbEscape
        @mode.abort_level
      end
      if id == 8 and !@items.empty? # c key: cheat -- collect a random item
        @items.shift
        score
      end
      if id == Gosu::KbF1
        @heads_up.show_notice("CHEATER!", 1.5) do
          @mode.complete_level
        end
      end
    end

    @mode.on :draw do
      @field_model.ground_image.draw 0,0,ZOrder::Background
      @items.each { |item| item.draw }
    end

  end

  private

  def add_item_if_needed(info)
    if rand(100) < 4 and @items.size < [@field_model.max_items_in_field, @field_model.collection_goal - @total_score].min
      x = rand * info.screen_width
      y = rand * info.screen_height
      @items << @field_model.build_new_item(x,y)
    end
  end

  def collect_items_near_tractor
    @items.reject! do |item|
      if Gosu::distance(@tractor.x, @tractor.y, item.x, item.y) < (@tractor.r + item.r)
        score
        true
      else
        false
      end
    end
  end

  def score
    @heads_up.count_up
    @total_score += 1
  end

  def check_for_done
    if @total_score == @field_model.collection_goal
      @heads_up.show_notice "You did it!" do
        @mode.complete_level
      end
    end
  end

end
