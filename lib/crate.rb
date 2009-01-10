class Crate
  constructor :handle, :bounds, :box_picture, :icon_picture, :accessors => true

  def draw(info)
    @box_picture.draw info
    @icon_picture.draw info
  end

  def center
    @bounds.center
  end
end
