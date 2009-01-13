class DumpTruckFactory
  constructor :object_context

  def build_dump_truck
    @object_context.within(:dump_truck) do |sub_context|
      sub_context.build_everything
      sub_context[:dump_truck]
    end
  end

  def build_controller(opts)
    require 'dump_truck_controller'
    DumpTruckController.new(
      :simulation => opts[:simulation],
      :dump_truck => opts[:dump_truck],
      :viewport_controller => opts[:viewport_controller]
    )
  end

end
