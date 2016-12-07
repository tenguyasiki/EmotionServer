require "./servo-command.rb"

class MessageToServoCommandTranslator
  attr_accessor :sensor_vals
  @default_speed = nil

  def initialize
    @default_speed = 10
    @sensor_vals = {
      "サーボ1の角度"=>0,
      "サーボ1のスピード"=>1,
      "サーボ0の角度"=>0,
      "サーボ0のスピード"=>1
    }
  end

  def var_update (var_name, var_val)
    @sensor_vals[var_name] = var_val
  end

  def translate(message)
    commands = []

    case message
    when "servo-reset"
      commands.push(ServoCommand.new(0, 1, 0, 255))
      commands.push(ServoCommand.new(0, 0, 0, 255))
    when "サーボをうごかす"
      puts @sensor_vals
      commands.push(ServoCommand.new(0, 1, @sensor_vals["サーボ1の角度"].to_i, @sensor_vals["サーボ1のスピード"].to_i))
      commands.push(ServoCommand.new(0, 0, @sensor_vals["サーボ0の角度"].to_i, @sensor_vals["サーボ0のスピード"].to_i))
    end

    return commands
  end

end
