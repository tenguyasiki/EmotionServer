require "rubygems"
require "arduino_firmata"

class ServoCommandExecuter

  ARDUINO_SERIAL_PORT_0 = "COM3"
  SERVO_PIN_0 = 4
  SERVO_PIN_1 = 9


  def initialize(arduino_serial_ports)
    @arduinos = []
    arduino_serial_ports.each_with_index{|port, index|
      @arduinos[index] = ArduinoFirmata.connect(port)
    }
    @servo_pins = [SERVO_PIN_0, SERVO_PIN_1]
  end

  def execute(commands)
    if commands.size == 1 then
      inner_execute(commands[0])
    else
      inner_sysex_execute(@arduinos[0], commands)
    end
  end

  private

    def inner_execute(command)
      arduino = @arduinos[command.arduino_id]
      servo_pin = @servo_pins[command.servo_id]
      angle = command.angle
      speed = command.speed

      puts "aruduino_id:#{command.arduino_id}, servo_pin:#{servo_pin}, angle:#{angle}"
      arduino.servo_write(servo_pin, angle)
      arduino.sysex 0x01, [servo_pin, angle, speed]
    end

    # ここに届くcommandsは 引数のarduinoを対象としたものだけという前提とする
    def inner_sysex_execute(arduino, commands)
      params = Array.new

      params.push(commands.size)
      commands.each do |command|
        servo_pin = @servo_pins[command.servo_id]
        angle = command.angle
        speed = command.speed

        params.push(servo_pin)
        params.push(angle)
        params.push(speed)

        puts "aruduino_id:#{command.arduino_id}, servo_pin:#{servo_pin}, angle:#{angle}, speed:#{speed}"
      end


      puts "params:#{params}"
      ## #define SYSEX_VARSPEED_SERVO  0x02
      arduino.sysex 0x02, params
    end

end
