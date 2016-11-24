require "./servo-command.rb"

class MessageToServoCommandTranslator
  @default_speed = nil

  def initialize
    @default_speed = 10
    
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
    end
    
    return commands
  end
  
end
