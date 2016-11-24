require "./message-to-servo-command-translator.rb"
require "./servo-command-executer.rb"

class MessageHandler
  
  def initialize(arduino_serial_ports)
    @translator = MessageToServoCommandTranslator.new()
    @executer = ServoCommandExecuter.new(arduino_serial_ports)
  end
  
  def handle(message)
    puts message
    commands = @translator.translate(message)
    @executer.execute(commands)
  end
  
end
