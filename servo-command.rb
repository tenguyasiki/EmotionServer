class ServoCommand

  def initialize(arduino_id, servo_id, angle, speed)
    @arduino_id = arduino_id
    @servo_id = servo_id
    @angle = angle
    @speed = speed
  end
  
  attr_accessor :arduino_id, :servo_id, :angle, :speed

end
