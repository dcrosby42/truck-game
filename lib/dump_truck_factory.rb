require 'dump_truck_controller'
class DumpTruckFactory
  constructor :object_context, :shape_registry

  def build_dump_truck
    truck = @object_context.within(:dump_truck) do |sub_context|
      sub_context.build_everything
      sub_context[:dump_truck]
    end
#    truck.add_to_shape_registry(@shape_registry)
    truck
  end

  def build_controller(opts)
    DumpTruckController.new(
      :simulation => opts[:simulation],
      :dump_truck => opts[:dump_truck]
    )
  end

end
