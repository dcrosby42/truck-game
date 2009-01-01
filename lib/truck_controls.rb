class TruckControls
  attr_accessor :drive_left, :drive_right, :brake, :close_bucket, :open_bucket

  def clear
    @drive_left = false
    @drive_right = false
    @brake = false
    @open_bucket = false
    @close_bucket = false
  end
end
