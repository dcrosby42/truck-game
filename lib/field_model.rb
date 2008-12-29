require 'corn'

class FieldModel
  attr_accessor :collection_goal, :max_items_in_field, :item_class, :ground_image, :multi_item_description

  constructor :media_loader do
    @collection_goal = 1
    @max_items_in_field = 1
  end

  def build_new_item(x,y)
    item = item_class.new(@media_loader)
    item.x = x
    item.y = y
    item
  end

  def goal_description
    "You need #{collection_goal} #{multi_item_description}."
  end

end
