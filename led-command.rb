class LedCommand

  def initialize(arduino_id, blight_time, red, green, blue)
    @arduino_id = arduino_id
    @msec = blight_time
    @red = red
    @green = green
    @blue = blue
  end
  
  attr_accessor :arduino_id, :msec, :red, :green, :blue

end
