class ViewportController
  constructor :mode, :viewport do 
    @mode.on :update do |info|
      if info.letter_down? 'd'
        @viewport.x += 10
      end
      if info.letter_down? 'a'
        @viewport.x -= 10
      end
      if info.letter_down? 's'
        @viewport.y += 10
      end
      if info.letter_down? 'w'
        @viewport.y -= 10
      end
    end
  end
end
