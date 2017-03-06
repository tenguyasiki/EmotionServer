require "./message-to-servo-command-translator.rb"
require "./servo-command-executer.rb"

require 'pry'

class MessageHandler

  def initialize(arduino_serial_ports)
    @translator = MessageToServoCommandTranslator.new()
    @executer = ServoCommandExecuter.new(arduino_serial_ports)
  end

  def handle(message)
    puts "handle [#{message}]\n"
    
    case message[0]
    when "broadcast"
      commands = @translator.translate(message[1])
      @executer.execute(commands)
    when "sensor-update"
      #scratch variable change
      #put the var-> val mapping in to translator
      @translator.var_update(message[1], message[2])
    end
    
    str = @executer.SerialRead(0)
    #puts "SerialRead : #{str}\n"
  end

end
