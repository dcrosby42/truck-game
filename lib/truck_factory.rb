class TruckFactory
  constructor :object_context

  def build_truck
    @object_context.within(:dump_truck) do |sub_context|
      sub_context.build_everything
      sub_context[:truck]
    end
  end
end
