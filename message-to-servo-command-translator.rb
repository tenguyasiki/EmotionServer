require "./servo-command.rb"
require "./led-command.rb"

require 'pry'

class MessageToServoCommandTranslator
  attr_accessor :sensor_vals
  @default_speed = nil

  def initialize
    @default_speed = 10
    @sensor_vals = {
      "サーボ1の角度"=>0,
      "サーボ1のスピード"=>1,
      "サーボ0の角度"=>0,
      "サーボ0のスピード"=>1,
      "光る時間"=>0,
      "赤い光"=>0,
      "緑の光"=>0,
      "青い光"=>0
    }
  end

  def var_update (var_name, var_val)
    @sensor_vals[var_name] = var_val
  end

  def translate(message)

    commands = []
    puts "MessageToServoCommandTranslator.translate [#{message}]\n"

    case message
    when "servo-reset"
      commands.push(ServoCommand.new(0, 1, 0, 255))
      commands.push(ServoCommand.new(0, 0, 0, 255))
    when "サーボをうごかす"
      puts @sensor_vals
      commands.push(ServoCommand.new(0, 1, @sensor_vals["サーボ1の角度"].to_i, @sensor_vals["サーボ1のスピード"].to_i))
      commands.push(ServoCommand.new(0, 0, @sensor_vals["サーボ0の角度"].to_i, @sensor_vals["サーボ0のスピード"].to_i))
    when "LEDを光らせる"
      puts @sensor_vals
      red = _normalize( @sensor_vals["赤い光"] )
      green = _normalize( @sensor_vals["緑の光"] )
      blue = _normalize( @sensor_vals["青い光"] )
      
      commands.push(
        # アノードコモンのマルチカラーLED
        LedCommand.new(0, 
          @sensor_vals["光る時間"].to_i,  # sec
          red, green, blue
        )
      )
    end

    return commands
  end
  
  private
  def _normalize(sensor_val)
    if sensor_val.nil? then
      return 0
    end
    
    val = sensor_val.to_i
    val = val >= 100 ? 100 : val
    return 100 - val
  end

end
