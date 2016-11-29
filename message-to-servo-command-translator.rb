require "./servo-command.rb"

class MessageToServoCommandTranslator
  attr_accessor :sensor_vals
  @default_speed = nil

  def initialize
    @default_speed = 10
    @sensor_vals = {"servo1-angle"=>0, "servo1-speed"=>1, "servo0-angle"=>0, "servo0-speed"=>1}
  end

  def var_update (var_name, var_val)
    @sensor_vals[var_name] = var_val
  end

  def translate(message)
    commands = []

    case message
    when "なおる"
      commands.push(ServoCommand.new(0, 1, 90, @default_speed))
      commands.push(ServoCommand.new(0, 0, 90, @default_speed))
    when "おじぎ"
      commands.push(ServoCommand.new(0, 1, 90, @default_speed))
      commands.push(ServoCommand.new(0, 0, 40, @default_speed + 10))
    when "わらう"
      commands.push(ServoCommand.new(0, 1, 90, @default_speed + 40))
      commands.push(ServoCommand.new(0, 0, 120, @default_speed + 40))
    when "なく"
      commands.push(ServoCommand.new(0, 1, 90, @default_speed + 10))
      commands.push(ServoCommand.new(0, 0, 0, @default_speed))
    when "おこる"
      commands.push(ServoCommand.new(0, 1, 120, @default_speed + 20))
      commands.push(ServoCommand.new(0, 0, 120, @default_speed + 20))
    when "よろこぶ"
      commands.push(ServoCommand.new(0, 1, 160, @default_speed + 40))
      commands.push(ServoCommand.new(0, 0, 120, @default_speed + 40))
    when "サーボをうごかす"
      puts @sensor_vals
      commands.push(ServoCommand.new(0, 1, @sensor_vals["servo1-angle"].to_i, @sensor_vals["servo1-speed"].to_i))
      commands.push(ServoCommand.new(0, 0, @sensor_vals["servo0-angle"].to_i, @sensor_vals["servo0-speed"].to_i))
    end

    return commands
  end

end
