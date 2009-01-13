class DumpTruckControls
  attr_accessor :drive_left, :drive_right, :brake, :close_bucket, :open_bucket, :help_jump, :lock_bucket, :boost

  def clear
    @drive_left = false
    @drive_right = false
    @brake = false
    @open_bucket = false
    @close_bucket = false
    @lock_bucket = false
    @help_jump = false
    @boost = false
  end
end
