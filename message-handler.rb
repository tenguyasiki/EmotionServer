require "./message-to-servo-command-translator.rb"
require "./servo-command-executer.rb"

class MessageHandler

  def initialize(arduino_serial_ports)
    @translator = MessageToServoCommandTranslator.new()
    @executer = ServoCommandExecuter.new(arduino_serial_ports)
  end

  def handle(message)
    case message[0]
    when "broadcast"
      commands = @translator.translate(message[1])
      @executer.execute(commands)
    when "sensor-update"
      #scratch variable change
      #put the var-> val mapping in to translator
      @translator.sensor_vals[message[1]] = message[2]
    end
  end

end
