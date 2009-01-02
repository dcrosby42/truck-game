class ViewportController
  constructor :simulation, :viewport do 
    @simulation.on :update_frame do |info|
      if info.letter_down? 'p'
        @viewport.x += 10
      end
      if info.letter_down? 'o'
        @viewport.x -= 10
      end
      if info.letter_down? 'i'
        @viewport.y += 10
      end
      if info.letter_down? 'u'
        @viewport.y -= 10
      end
    end
  end
end
